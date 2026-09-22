/** @jsxImportSource @opentui/solid */
import { Plugin } from "@opencode/plugin/tui"
import { createEffect, createMemo, createSignal, on, Show } from "solid-js"

export default Plugin.define({
  id: "opencode-account-status",
  setup(api) {
    return api.ui.slot({
      append: "prompt.footer.status",
      render: (props) => {
        const session = createMemo(() => props.sessionID ? api.data.session.get(props.sessionID) : undefined)
        const location = createMemo(() => session()?.location ?? api.location ?? api.data.location.default())
        const [unavailable, setUnavailable] = createSignal(false)

        createEffect(on(location, (current) => {
          setUnavailable(false)
          void Promise.all([
            api.data.location.provider.sync(current),
            api.data.location.integration.sync(current),
          ]).catch(() => setUnavailable(true))
        }))

        const label = createMemo(() => {
          const providerID = session()?.model?.providerID
          if (!providerID) return
          const provider = api.data.location.provider.list(location())?.find((item) => item.id === providerID)
          if (!provider) return
          const integrationID = provider.integrationID ?? provider.id
          const integration = api.data.location.integration.list(location())?.find((item) => item.id === integrationID)
          if (!integration) return
          // V2 orders connections active-first and updates this cache on credential switches.
          const active = integration?.connections[0]
          if (active?.type === "credential") {
            return active.label.replace(/[\u0000-\u001f\u007f-\u009f]/g, " ").trim() || "Unnamed account"
          }
          if (active?.type === "env") return "Environment account"
          if (unavailable()) return "Account unavailable"
        })

        return (
          <Show when={label()}>
            <text fg={api.theme.text.muted} flexShrink={0}>{label()}</text>
          </Show>
        )
      },
    })
  },
})
