import assert from "node:assert/strict"
import { EventEmitter } from "node:events"
import { test } from "node:test"
import type { ModelInfo, SessionMessageInfo } from "@opencode/client"
import { contributeFooter, footerText, observeFooter, type FooterValue } from "./contributions"
import { contextUsage } from "./context"

test("only visible items receive separators", () => {
  assert.equal(footerText(["DigiPen", "", undefined, "Weekly 58% left", "resets in 5d 22h", "160.0K (40%)"]),
    "DigiPen · Weekly 58% left · resets in 5d 22h · 160.0K (40%)")
  assert.equal(footerText([undefined, " ", "160.0K (40%)", ""]), "160.0K (40%)")
  assert.equal(footerText([]), "")
  assert.equal(footerText([" Account\nname\x07 "]), "Account name")
})

for (const publisherFirst of [true, false]) {
  test(`contributions work with ${publisherFirst ? "publisher" : "footer"} loaded first`, () => {
    const renderer = new EventEmitter()
    const value = { sessionID: "a", items: ["Weekly 58% left"] }
    let current: readonly FooterValue[] = []
    const item = contributeFooter(renderer, "test")
    if (publisherFirst) item.update(value)
    const stop = observeFooter(renderer, (items) => { current = items })
    if (!publisherFirst) item.update(value)
    assert.deepEqual(current, [value])
    item.update({ sessionID: "b", items: ["Weekly 32% left"] })
    assert.equal(current[0].sessionID, "b")
    item.update()
    assert.deepEqual(current, [])
    item.dispose()
    stop()
    assert.deepEqual(renderer.eventNames(), [])
  })
}

test("ordering, footer reload, and overlapping publisher cleanup remain deterministic", () => {
  const renderer = new EventEmitter()
  let current: readonly FooterValue[] = []
  let stop = observeFooter(renderer, (items) => { current = items })
  const late = contributeFooter(renderer, "late", 80)
  const early = contributeFooter(renderer, "early", 20)
  late.update({ sessionID: "a", items: ["late"] })
  early.update({ sessionID: "a", items: ["old"] })
  assert.deepEqual(current.flatMap((item) => item.items), ["old", "late"])
  const replacement = contributeFooter(renderer, "early", 20)
  replacement.update({ sessionID: "a", items: ["new"] })
  early.dispose()
  assert.deepEqual(current.flatMap((item) => item.items), ["new", "late"])
  stop()
  current = []
  stop = observeFooter(renderer, (items) => { current = items })
  assert.deepEqual(current.flatMap((item) => item.items), ["new", "late"])
  replacement.dispose()
  replacement.update({ sessionID: "a", items: ["should not return"] })
  assert.deepEqual(current.flatMap((item) => item.items), ["late"])
  late.dispose()
  stop()
  assert.deepEqual(renderer.eventNames(), [])
})

test("separate terminal renderers do not share contributions", () => {
  const first = new EventEmitter()
  const second = new EventEmitter()
  let current: readonly FooterValue[] = []
  const stop = observeFooter(second, (items) => { current = items })
  const item = contributeFooter(first, "test")
  item.update({ sessionID: "same-session", items: ["private to first terminal"] })
  assert.deepEqual(current, [])
  item.dispose()
  stop()
})

const assistant = (id: string, input: number) => ({
  id, type: "assistant", model: { providerID: "provider", id: "model" },
  tokens: { input, output: 500, reasoning: 100, cache: { read: 400, write: 0 } },
}) as SessionMessageInfo
const models = [{ providerID: "provider", id: "model", limit: { context: 400000 } }] as ModelInfo[]

test("context uses the latest token report and includes cached and reasoning tokens", () => {
  const messages = [assistant("old", 10000), assistant("latest", 159000)]
  assert.equal(contextUsage(messages, models), "160.0K (40%)")
  assert.equal(contextUsage(messages, undefined), "160.0K")
  assert.equal(contextUsage([], models), undefined)
})

test("context respects undo boundaries and discards pre-compaction usage", () => {
  const before = assistant("before", 159000)
  const compaction = { id: "compact", type: "compaction", status: "completed" } as SessionMessageInfo
  const after = assistant("after", 39000)
  assert.equal(contextUsage([before, compaction], models), undefined)
  assert.equal(contextUsage([before, compaction, after], models), "40.0K (10%)")
  assert.equal(contextUsage([before, compaction, after], models, "compact"), "160.0K (40%)")
  assert.equal(contextUsage([before, compaction, after], models, "missing"), undefined)
})
