export interface UsageWindow {
  seconds: number
  remaining: number
  resetsAt: number
}

export interface Usage {
  status: "ready" | "inactive" | "unavailable"
  windows: UsageWindow[]
  plan?: string
  updatedAt?: number
  message?: string
}

function record(value: unknown): Record<string, unknown> {
  return value !== null && typeof value === "object" && !Array.isArray(value)
    ? value as Record<string, unknown> : {}
}

export function accountID(access: string, metadata?: Record<string, unknown>): string | undefined {
  if (typeof metadata?.accountId === "string" && metadata.accountId) return metadata.accountId
  try {
    const payload = record(JSON.parse(Buffer.from(access.split(".")[1], "base64url").toString()))
    const id = record(payload["https://api.openai.com/auth"]).chatgpt_account_id
    return typeof id === "string" && id ? id : undefined
  } catch {
    return undefined
  }
}

export function parseUsage(value: unknown, now = Date.now()): Usage {
  const body = record(value)
  const limits = record(body.rate_limit)
  const windows: UsageWindow[] = []
  for (const candidate of [limits.primary_window, limits.secondary_window]) {
    if (candidate == null) continue
    const window = record(candidate)
    const used = window.used_percent
    const seconds = window.limit_window_seconds
    const reset = window.reset_at
    if (typeof used !== "number" || !Number.isFinite(used) || used < 0 || used > 100
      || typeof seconds !== "number" || !Number.isFinite(seconds) || seconds <= 0
      || typeof reset !== "number" || !Number.isFinite(reset) || reset <= 0 || reset > 8.64e12) {
      throw new Error("Invalid usage window")
    }
    windows.push({ seconds, remaining: Math.round((100 - used) * 10) / 10, resetsAt: reset * 1000 })
  }
  if (!windows.length) throw new Error("No usage windows")
  const plan = typeof body.plan_type === "string"
    ? body.plan_type.replace(/[\u0000-\u001f\u007f-\u009f]/g, " ").slice(0, 80) : undefined
  return { status: "ready", windows, plan, updatedAt: now }
}

export async function fetchUsage(access: string, id: string | undefined, signal: AbortSignal): Promise<Usage> {
  let response: Response
  try {
    response = await fetch("https://chatgpt.com/backend-api/wham/usage", {
      headers: {
        Authorization: `Bearer ${access}`,
        Accept: "application/json",
        ...(id ? { "ChatGPT-Account-Id": id } : {}),
      },
      redirect: "error",
      signal: AbortSignal.any([signal, AbortSignal.timeout(10_000)]),
    })
  } catch {
    return unavailable("Could not reach ChatGPT usage. Try again shortly.")
  }
  if (!response.ok) {
    await response.body?.cancel()
    return unavailable(response.status === 401 || response.status === 403
      ? "ChatGPT usage authentication failed. Reconnect OpenAI using /connect."
      : response.status === 429 ? "ChatGPT usage is rate-limited. Try again shortly."
      : `ChatGPT usage returned HTTP ${response.status}.`)
  }
  try {
    return parseUsage(await response.json())
  } catch {
    return unavailable("ChatGPT did not return valid plan-limit windows.")
  }
}

export function unavailable(message: string): Usage {
  return { status: "unavailable", windows: [], message }
}

export function windowLabel(seconds: number): string {
  if (seconds === 604800) return "Weekly"
  if (seconds % 86400 === 0) return `${seconds / 86400}d`
  if (seconds % 3600 === 0) return `${seconds / 3600}h`
  return `${Math.round(seconds / 60)}m`
}

export function resetIn(resetsAt: number, now = Date.now()): string {
  const minutes = Math.ceil((resetsAt - now) / 60_000)
  if (minutes <= 0) return "reset due"
  if (minutes >= 1440) return `${Math.floor(minutes / 1440)}d ${Math.floor(minutes % 1440 / 60)}h`
  if (minutes >= 60) return `${Math.floor(minutes / 60)}h ${minutes % 60}m`
  return `${minutes}m`
}
