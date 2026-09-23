import assert from "node:assert/strict"
import { test } from "node:test"
import plugin from "./index"
import { accountID, fetchUsage, parseUsage, resetIn, windowLabel } from "./usage"

const weekly = { used_percent: 36, limit_window_seconds: 604800, reset_at: 1800000000 }
const payload = { plan_type: "pro", rate_limit: { primary_window: null, secondary_window: weekly } }

test("weekly-only plans and differently ordered windows retain API durations", () => {
  const usage = parseUsage(payload, 1000)
  assert.deepEqual(usage.windows, [{ seconds: 604800, remaining: 64, resetsAt: 1800000000000 }])
  assert.equal(usage.updatedAt, 1000)
  assert.equal(windowLabel(usage.windows[0].seconds), "Weekly")
  const both = parseUsage({ rate_limit: {
    primary_window: weekly,
    secondary_window: { ...weekly, used_percent: 100, limit_window_seconds: 18000 },
  } })
  assert.deepEqual(both.windows.map((window) => [windowLabel(window.seconds), window.remaining]), [["Weekly", 64], ["5h", 0]])
  assert.equal(resetIn(1000, 2000), "reset due")
})

test("malformed data never becomes a healthy quota reading", () => {
  for (const value of [null, {}, { rate_limit: {} }]) assert.throws(() => parseUsage(value))
  for (const change of [{ used_percent: "36" }, { used_percent: -1 }, { used_percent: 101 },
    { used_percent: NaN }, { reset_at: null }, { limit_window_seconds: 0 }]) {
    assert.throws(() => parseUsage({ rate_limit: { primary_window: { ...weekly, ...change } } }))
  }
})

test("account routing uses metadata or the account claim, tolerating malformed tokens", () => {
  const access = `header.${Buffer.from(JSON.stringify({
    "https://api.openai.com/auth": { chatgpt_account_id: "claim-account" },
  })).toString("base64url")}.signature`
  assert.equal(accountID(access), "claim-account")
  assert.equal(accountID(access, { accountId: "selected-account" }), "selected-account")
  assert.equal(accountID("not-a-token"), undefined)
})

test("usage requests route credentials only to ChatGPT and sanitize failures", async (t) => {
  t.mock.method(globalThis, "fetch", async (url: string, options: RequestInit) => {
    assert.equal(url, "https://chatgpt.com/backend-api/wham/usage")
    assert.equal(options.redirect, "error")
    const headers = new Headers(options.headers)
    assert.equal(headers.get("Authorization"), "Bearer test-secret")
    assert.equal(headers.get("ChatGPT-Account-Id"), "account-a")
    return Response.json(payload)
  })
  const signal = new AbortController().signal
  assert.equal((await fetchUsage("test-secret", "account-a", signal)).status, "ready")
  for (const status of [401, 403, 429, 500]) {
    t.mock.method(globalThis, "fetch", async () => new Response("test-secret", { status }))
    const result = await fetchUsage("test-secret", undefined, signal)
    assert.equal(result.status, "unavailable")
    assert.ok(!JSON.stringify(result).includes("test-secret"))
  }
  t.mock.method(globalThis, "fetch", async () => { throw new Error("test-secret") })
  assert.ok(!JSON.stringify(await fetchUsage("test-secret", undefined, signal)).includes("test-secret"))
})

test("RPC rejects mismatched accounts and API keys, and drops in-flight account switches", async (t) => {
  let active = { type: "credential", id: "a", label: "Account A" }
  let credential: object = { type: "key", key: "test-key" }
  let calls = 0
  let read!: (input: unknown, context: { signal: AbortSignal }) => Promise<unknown>
  await plugin.setup({
    rpc: { register: async (_definition: unknown, handlers: { read: typeof read }) => { read = handlers.read } },
    integration: { connection: {
      active: async () => active,
      resolve: async () => credential,
    } },
  } as unknown as Parameters<typeof plugin.setup>[0])
  t.mock.method(globalThis, "fetch", async () => {
    calls++
    active = { ...active, id: "b" }
    return Response.json(payload)
  })
  const context = { signal: new AbortController().signal }
  const inactive = { status: "inactive", windows: [] }
  assert.deepEqual(await read({ credentialID: "b" }, context), inactive)
  assert.deepEqual(await read({ credentialID: "a" }, context), inactive)
  assert.equal(calls, 0)
  credential = { type: "oauth", access: "test-access", metadata: { accountId: "a" } }
  assert.deepEqual(await read({ credentialID: "a" }, context), inactive)
  assert.equal(calls, 1)
})
