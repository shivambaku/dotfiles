/** @jsxImportSource @opentui/solid */
// OpenCode supplies the shared Solid runtime when loading .tsx TUI modules.
import type { Context } from "@opencode/plugin/tui/context"
import { createEffect, createMemo, createSignal, on, onCleanup } from "solid-js"
import { OpenAIUsage } from "./rpc"
import { unavailable, type Usage } from "./usage"

export function createUsageState(api: Context) {
  const rpc = api.client.rpc(OpenAIUsage)
  const [usage, setUsage] = createSignal<Usage>()
  const [loading, setLoading] = createSignal(false)
  const [initializationError, setInitializationError] = createSignal<string>()
  const [now, setNow] = createSignal(Date.now())
  const session = createMemo(() => {
    const route = api.ui.router.current()
    return route.type === "session" ? api.data.session.get(route.sessionID) : undefined
  })
  const location = createMemo(() => session()?.location ?? api.location ?? api.data.location.default())
  const connection = createMemo(() => {
    const providerID = session()?.model?.providerID
    const provider = api.data.location.provider.list(location())?.find((item) => item.id === providerID)
    if (!provider || (provider.integrationID ?? provider.id) !== "openai") return
    const active = api.data.location.integration.list(location())?.find((item) => item.id === "openai")?.connections[0]
    // The server resolves the credential and hides API-key connections.
    return active?.type === "credential" ? active : undefined
  })
  const scope = createMemo(() => JSON.stringify([location().directory, connection()?.id]))
  let request: AbortController | undefined
  let disposed = false

  async function refresh() {
    if (disposed || request) return
    const current = location()
    const key = scope()
    const controller = new AbortController()
    request = controller
    setLoading(true)
    setInitializationError(undefined)
    const isCurrent = () => !controller.signal.aborted && scope() === key
    try {
      // Retry missing metadata on every refresh. Cache recovery can also make
      // connection() available independently of this initialization attempt.
      if (!api.data.location.provider.list(current) || !api.data.location.integration.list(current)) {
        try {
          await Promise.all([
            api.data.location.provider.sync(current),
            api.data.location.integration.sync(current),
          ])
        } catch {
          if (isCurrent()) setInitializationError("Unable to load account data. Retrying on the next refresh.")
          return
        }
      }
      if (!isCurrent()) return
      const credential = connection()
      if (!credential) return
      const result = await rpc.read({ credentialID: credential.id }, {
        location: current, signal: controller.signal,
      }) as Usage
      if (isCurrent()) setUsage(result)
    } catch {
      if (isCurrent()) setUsage(unavailable("OpenAI usage plugin is unavailable on the connected server."))
    } finally {
      if (request === controller) {
        request = undefined
        setLoading(false)
      }
    }
  }

  createEffect(on(scope, () => {
    request?.abort()
    request = undefined
    setUsage(undefined)
    setLoading(false)
    void refresh()
  }))
  const timer = setInterval(() => { setNow(Date.now()); void refresh() }, 60_000)
  onCleanup(() => {
    disposed = true
    clearInterval(timer)
    request?.abort()
  })

  return { usage, loading, initializationError, now, connection, refresh }
}
