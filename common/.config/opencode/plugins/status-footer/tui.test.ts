import assert from "node:assert/strict"
import { EventEmitter } from "node:events"
import { mock, test, type TestContext } from "node:test"
import type { Context } from "@opencode/plugin/tui/context"
import { createRoot } from "solid-js"
import { contributeFooter } from "./contributions"

// Run emitted JSX with --conditions=browser --experimental-test-module-mocks.
// Stub the terminal host while exercising the real footer component and handlers.
interface Element {
  type: string
  props: {
    children?: unknown
    onMouseUp?: (event: { button: number; stopPropagation(): void }) => void
  }
}

const jsx = (type: string | ((props: object) => unknown), props: object) =>
  typeof type === "function" ? type(props) : { type, props }

mock.module("@opencode/plugin/tui", {
  exports: { Plugin: { define: (plugin: unknown) => plugin } },
})
mock.module("@opentui/solid/jsx-runtime", { exports: { jsx, jsxs: jsx } })

function textNodes(value: unknown): Element[] {
  if (typeof value === "function") return textNodes(value())
  if (Array.isArray(value)) return value.flatMap(textNodes)
  if (!value || typeof value !== "object") return []
  const element = value as Element
  return element.type === "text" ? [element] : textNodes(element.props.children)
}

async function renderFooter(t: TestContext, children: number, shells: number, showDetails = true, mode = "normal") {
  const { default: plugin } = await import("./tui")
  const renderer = new EventEmitter()
  const quota = contributeFooter(renderer, "fixture")
  quota.update({ sessionID: "parent", items: ["Weekly 58% left"] })
  t.after(() => quota.dispose())
  const commands: string[] = []
  let rendered: unknown
  createRoot((dispose) => {
    t.after(dispose)
    plugin.setup({
      renderer,
      theme: { text: { base: "white", muted: "gray" } },
      keymap: { dispatch: (command: string) => { commands.push(command) } },
      ui: { slot: (claim: { render: (props: object) => unknown }) => {
        rendered = claim.render({ sessionID: "parent", mode, showDetails })
        return () => {}
      } },
      data: {
        session: {
          get: () => ({ model: { providerID: "provider" }, location: { directory: "/project" } }),
          family: () => ["parent", ...Array.from({ length: children }, (_, index) => `child-${index}`)],
          status: () => "running", cost: () => 0, message: { list: () => [] },
        },
        shell: { list: () => Array.from({ length: shells }, () => ({ metadata: { sessionID: "parent" } })) },
        location: {
          provider: { list: () => [{ id: "provider" }], sync: async () => {} },
          integration: { list: () => [{ id: "provider", connections: [{ type: "credential", label: "Account" }] }], sync: async () => {} },
          model: { list: () => [], sync: async () => {} },
        },
      },
    } as unknown as Context)
  })
  const nodes = textNodes(rendered)
  return { nodes, commands, text: nodes.map((node) => node.props.children).join("") }
}

for (const [children, shells, activity] of [[1, 0, "1 subagent"], [0, 1, "1 shell"], [1, 1, "1 subagent · 1 shell"]] as const) {
  test(`${activity}: only the activity segment opens child navigation`, async (t) => {
    const result = await renderFooter(t, children, shells)
    assert.equal(result.text, `${activity} · Account · Weekly 58% left`)
    const clickable = result.nodes.filter((node) => node.props.onMouseUp)
    assert.equal(clickable.length, 1)
    assert.equal(clickable[0].props.children, activity)
    let stopped = 0
    const event = { button: 2, stopPropagation: () => { stopped++ } }
    clickable[0].props.onMouseUp!(event)
    assert.deepEqual(result.commands, [])
    assert.equal(stopped, 0)
    clickable[0].props.onMouseUp!({ ...event, button: 0 })
    assert.deepEqual(result.commands, ["session.child.first"])
    assert.equal(stopped, 1)
  })
}

test("idle and shell-mode footers remain non-clickable and have no dangling separator", async (t) => {
  const idle = await renderFooter(t, 0, 0)
  assert.equal(idle.text, "Account · Weekly 58% left")
  assert.ok(idle.nodes.every((node) => !node.props.onMouseUp))
  const shell = await renderFooter(t, 1, 1, true, "shell")
  assert.equal(shell.text, "esc exit shell mode")
  assert.ok(shell.nodes.every((node) => !node.props.onMouseUp))
  const compact = await renderFooter(t, 1, 0, false)
  assert.equal(compact.text, "1 subagent")
  assert.equal(compact.nodes.length, 1)
  assert.ok(compact.nodes[0].props.onMouseUp)
})
