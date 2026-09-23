/** @jsxImportSource @opentui/solid */
import { Plugin } from "@opencode/plugin/tui"
import type { Context } from "@opencode/plugin/tui/context"
import { createEffect, For, onCleanup, Show } from "solid-js"
import { contributeFooter } from "../status-footer/contributions"
import { createUsageState } from "./state"
import { resetIn, windowLabel } from "./usage"

function UsageController(api: Context) {
  const { usage, loading, initializationError, now, connection, refresh } = createUsageState(api)

  function openDialog() {
    void refresh()
    api.ui.dialog.set({ size: "medium" })
    api.ui.dialog.show(() => (
      <box flexDirection="column" gap={1} padding={1}>
        <text fg={api.theme.text.base}>OpenAI plan usage</text>
        <Show when={connection()} fallback={
          <text fg={api.theme.text.muted}>
            {loading() ? "Loading account data…" : initializationError() ?? "Select an OpenAI model connected through ChatGPT OAuth."}
          </text>
        }>
          <text fg={api.theme.text.muted}>{connection()?.label.replace(/[\u0000-\u001f\u007f-\u009f]/g, " ")}</text>
          <Show when={loading()}><text fg={api.theme.text.muted}>Refreshing…</text></Show>
          <Show when={usage()?.message}><text fg={api.theme.text.muted}>{usage()?.message}</text></Show>
          <Show when={usage()?.status === "inactive"}><text fg={api.theme.text.muted}>No active ChatGPT OAuth account. Check OpenAI in /connect.</text></Show>
          <Show when={usage()?.status === "ready"}>
            <Show when={usage()?.plan}><text fg={api.theme.text.muted}>Plan: {usage()?.plan}</text></Show>
            <For each={usage()?.windows}>{(window) => {
              const filled = Math.round(window.remaining / 5)
              return <box flexDirection="column">
                <text fg={api.theme.text.base}>{windowLabel(window.seconds)} limit</text>
                <text fg={api.theme.text.base}>{"█".repeat(filled)}{"░".repeat(20 - filled)} {window.remaining}% left</text>
                <text fg={api.theme.text.muted}>Resets: {resetIn(window.resetsAt, now())} · {new Date(window.resetsAt).toLocaleString()}</text>
              </box>
            }}</For>
            <text fg={api.theme.text.muted}>Updated: {new Date(usage()!.updatedAt!).toLocaleTimeString()}</text>
          </Show>
        </Show>
      </box>
    ))
  }

  api.keymap.layer(() => ({
    mode: "global",
    commands: [{
      id: "openai-usage.show", title: "OpenAI plan usage", group: "OpenAI", palette: true,
      slash: { name: "openai-usage" }, run: openDialog,
    }],
  }))
  const footer = contributeFooter(api.renderer, "openai-usage", 50)
  createEffect(() => {
    const route = api.ui.router.current()
    const value = usage()
    if (route.type !== "session" || !connection() || !value || value.status === "inactive") {
      footer.update()
      return
    }
    footer.update({
      sessionID: route.sessionID,
      items: value.status === "ready"
        ? value.windows.flatMap((window) => [
          `${windowLabel(window.seconds)} ${window.remaining}% left`,
          window.resetsAt <= now() ? "reset due" : `resets in ${resetIn(window.resetsAt, now())}`,
        ])
        : ["OpenAI usage unavailable"],
    })
  })
  onCleanup(() => footer.dispose())
  return null
}

export default Plugin.define({
  id: "opencode-openai-usage-tui",
  setup(api) {
    return api.ui.slot({ append: "app", render: () => UsageController(api) })
  },
})
