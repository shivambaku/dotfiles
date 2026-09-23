/** @jsxImportSource @opentui/solid */
import { Plugin } from "@opencode/plugin/tui"
import { createEffect, createMemo, createSignal, on, onCleanup, Show } from "solid-js"
import { FOOTER_SEPARATOR, footerText, observeFooter, type FooterValue } from "./contributions"
import { contextUsage } from "./context"

const currency = new Intl.NumberFormat("en-US", { style: "currency", currency: "USD" })

export default Plugin.define({
  id: "opencode-status-footer",
  setup(api) {
    return api.ui.slot({
      append: "prompt.footer",
      render: (props) => {
        const session = createMemo(() => props.sessionID ? api.data.session.get(props.sessionID) : undefined)
        const location = createMemo(() => session()?.location ?? api.location ?? api.data.location.default())
        const [unavailable, setUnavailable] = createSignal(false)
        const [activityHovered, setActivityHovered] = createSignal(false)
        const [contributions, setContributions] = createSignal<readonly FooterValue[]>([])
        onCleanup(observeFooter(api.renderer, setContributions))

        createEffect(on(location, (current) => {
          setUnavailable(false)
          void Promise.all([
            api.data.location.provider.sync(current),
            api.data.location.integration.sync(current),
            api.data.location.model.sync(current),
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

        const activity = createMemo(() => {
          const id = props.sessionID
          if (props.mode !== "normal" || !id) return ""
          const children = api.data.session.family(id).filter((child) => child !== id && api.data.session.status(child) === "running").length
          const shells = api.data.shell.list(location()).filter((shell) => shell.metadata.sessionID === id).length
          return footerText([
            children ? `${children} subagent${children === 1 ? "" : "s"}` : undefined,
            shells ? `${shells} shell${shells === 1 ? "" : "s"}` : undefined,
          ])
        })
        const text = createMemo(() => {
          if (props.mode === "shell") return "esc exit shell mode"
          const id = props.sessionID
          if (!id || !props.showDetails) return ""
          const cost = api.data.session.cost(id)
          return footerText([
            label(),
            ...contributions().filter((item) => item.sessionID === id).flatMap((item) => item.items),
            contextUsage(api.data.session.message.list(id), api.data.location.model.list(location()), session()?.revert?.messageID),
            cost > 0 ? currency.format(cost) : undefined,
          ])
        })

        return (
          <Show when={activity() || text()}>
            <box flexDirection="row" flexShrink={1} minWidth={0}>
              <Show when={activity()}>
                <text
                  fg={activityHovered() ? api.theme.text.base : api.theme.text.muted}
                  flexShrink={0}
                  wrapMode="none"
                  onMouseOver={() => setActivityHovered(true)}
                  onMouseOut={() => setActivityHovered(false)}
                  onMouseUp={(event) => {
                    if (event.button !== 0) return
                    event.stopPropagation()
                    api.keymap.dispatch("session.child.first")
                  }}
                >{activity()}</text>
              </Show>
              <Show when={activity() && text()}>
                <text fg={api.theme.text.muted} flexShrink={0}>{FOOTER_SEPARATOR}</text>
              </Show>
              <Show when={text()}>
                <text fg={api.theme.text.muted} flexShrink={1} minWidth={0} wrapMode="none" truncate>{text()}</text>
              </Show>
            </box>
          </Show>
        )
      },
    })
  },
})
