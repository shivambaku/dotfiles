import fs from "node:fs/promises";
import os from "node:os";
import path from "node:path";

const VERSION = 1;
const HEARTBEAT_MS = 20_000;

const paneId = process.env.WEZTERM_PANE;
const workspace = process.env.WEZTERM_WORKSPACE;
const stateDir = path.join(
  process.env.XDG_STATE_HOME || path.join(os.homedir(), ".local", "state"),
  "opencode",
  "wezterm-sessions",
);

function sessionIDFromProperties(properties) {
  if (typeof properties?.sessionID === "string" && properties.sessionID) {
    return properties.sessionID;
  }

  if (typeof properties?.info?.id === "string" && properties.info.id) {
    return properties.info.id;
  }

  return undefined;
}

function statusFromEvent(event) {
  const type = event?.type;
  const statusType = event?.properties?.status?.type;

  if (type === "session.status") {
    switch (statusType) {
      case "busy":
        return { status: "working", detail: "busy" };
      case "idle":
        return { status: "idle", detail: "idle" };
      case "retry":
        return { status: "working", detail: "retry" };
      default:
        return { status: "unknown", detail: statusType || type };
    }
  }

  switch (type) {
    case "session.idle":
      return { status: "idle", detail: "idle" };
    case "permission.asked":
      return { status: "blocked", detail: "permission" };
    case "question.asked":
      return { status: "blocked", detail: "question" };
    case "session.error":
      return { status: "error", detail: "error" };
    case "session.created":
    case "session.updated":
      return undefined;
    case "permission.replied":
    case "question.replied":
    case "question.rejected":
      return { status: "working", detail: "resumed" };
    default:
      return undefined;
  }
}

async function writeState(sessionID, state) {
  if (!sessionID) {
    return;
  }

  await fs.mkdir(stateDir, { recursive: true });

  const file = path.join(stateDir, `${sessionID}.json`);
  const tmp = `${file}.${process.pid}.tmp`;
  await fs.writeFile(tmp, `${JSON.stringify(state)}\n`, "utf8");
  await fs.rename(tmp, file);
}

export const WeztermSessionStatePlugin = async ({ directory, worktree }) => {
  if (!paneId) {
    return {};
  }

  const sessions = new Map();

  async function report(sessionID, patch = {}) {
    const previous = sessions.get(sessionID) || {};
    const next = {
      version: VERSION,
      session_id: sessionID,
      pane_id: paneId,
      workspace,
      directory,
      worktree,
      status: "unknown",
      detail: "seen",
      pid: process.pid,
      ...previous,
      ...patch,
      updated_at: Date.now(),
    };

    sessions.set(sessionID, next);
    await writeState(sessionID, next);
  }

  const heartbeat = setInterval(() => {
    for (const [sessionID, state] of sessions) {
      report(sessionID, state).catch(() => {});
    }
  }, HEARTBEAT_MS);
  heartbeat.unref?.();

  return {
    event: async ({ event }) => {
      const properties = event?.properties ?? {};
      const sessionID = sessionIDFromProperties(properties);
      if (!sessionID) {
        return;
      }

      await report(sessionID, statusFromEvent(event));
    },
  };
};
