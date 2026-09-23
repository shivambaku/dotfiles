import assert from "node:assert/strict"
import { setImmediate } from "node:timers/promises"
import { test } from "node:test"
import type { Context } from "@opencode/plugin/tui/context"
import { batch, createRoot, createSignal } from "solid-js"
import { createUsageState } from "./state"
import type { Usage } from "./usage"

// Run with Node's --conditions=browser so Solid uses its reactive client runtime.
for (const failure of ["provider", "integration"]) {
  for (const recovery of ["timer", "manual", "cache"]) {
    test(`${recovery} refresh recovers from an initial ${failure} sync failure`, async (t) => {
      t.mock.timers.enable({ apis: ["setInterval"] })
      const providerData = [{ id: "openai" }]
      const integrationData = [{ id: "openai", connections: [{ type: "credential", id: "a", label: "Account A" }] }]
      const snapshot: Usage = {
        status: "ready", windows: [{ seconds: 604800, remaining: 64, resetsAt: 1800000000000 }],
      }
      let offline = true
      let reads = 0
      let attempts = 0
      const fixture = createRoot((dispose) => {
        const [providers, setProviders] = createSignal<typeof providerData>()
        const [integrations, setIntegrations] = createSignal<typeof integrationData>()
        const state = createUsageState({
          client: { rpc: () => ({ read: async () => { reads++; return snapshot } }) },
          ui: { router: { current: () => ({ type: "session", sessionID: "s" }) } },
          data: {
            session: { get: () => ({ model: { providerID: "openai" }, location: { directory: "/project" } }) },
            location: {
              provider: { list: providers, sync: async () => {
                attempts++
                if (offline && failure === "provider") throw new Error("Disconnected")
                setProviders(providerData)
              } },
              integration: { list: integrations, sync: async () => {
                if (offline && failure === "integration") throw new Error("Disconnected")
                setIntegrations(integrationData)
              } },
            },
          },
        } as unknown as Context)
        return { state, dispose, recoverCache: () => batch(() => {
          setProviders(providerData)
          setIntegrations(integrationData)
        }) }
      })
      t.after(fixture.dispose)
      await setImmediate()
      assert.equal(reads, 0)
      assert.match(fixture.state.initializationError()!, /Unable to load account data/)
      offline = false
      if (recovery === "timer") t.mock.timers.tick(60_000)
      if (recovery === "manual") await fixture.state.refresh()
      if (recovery === "cache") fixture.recoverCache()
      await setImmediate()
      assert.equal(reads, 1)
      assert.equal(attempts, recovery === "cache" ? 1 : 2)
      assert.equal(fixture.state.connection()?.id, "a")
      assert.deepEqual(fixture.state.usage(), snapshot)
      assert.equal(fixture.state.initializationError(), undefined)
      assert.equal(fixture.state.loading(), false)
      fixture.dispose()
      t.mock.timers.tick(60_000)
      await setImmediate()
      assert.equal(reads, 1)
    })
  }
}
