import type { ModelInfo, SessionMessageInfo } from "@opencode/client"

export function contextUsage(messages: readonly SessionMessageInfo[], models: readonly ModelInfo[] | undefined, revertID?: string): string | undefined {
  const end = revertID ? messages.findIndex((message) => message.id === revertID) : messages.length
  if (end < 0) return
  // Match OpenCode's context counter: only the latest reported assistant usage,
  // before any revert boundary and after the last completed compaction.
  for (let index = end - 1; index >= 0; index--) {
    const message = messages[index]
    if (message.type === "compaction" && message.status === "completed") return
    if (message.type !== "assistant" || !message.tokens) continue
    const { input, output, reasoning, cache } = message.tokens
    const total = input + output + reasoning + cache.read + cache.write
    if (total <= 0) return
    const limit = models?.find((model) => model.providerID === message.model.providerID && model.id === message.model.id)?.limit.context
    const count = total >= 1e6 ? `${(total / 1e6).toFixed(1)}M`
      : total >= 1000 ? `${(total / 1000).toFixed(1)}K` : String(total)
    return limit ? `${count} (${Math.round(total / limit * 100)}%)` : count
  }
}
