import type { Plugin } from "@opencode/plugin"
import { OpenAIUsage } from "./rpc"
import { accountID, fetchUsage, unavailable } from "./usage"

export default {
  id: "opencode-openai-usage",
  async setup(api) {
    await api.rpc.register(OpenAIUsage, {
      read: async (input, context) => {
        const { credentialID } = input as { credentialID: string }
        const inactive = { status: "inactive", windows: [] }
        try {
          const connection = await api.integration.connection.active("openai")
          if (connection?.type !== "credential" || connection.id !== credentialID) {
            return inactive
          }
          // Resolve through OpenCode so its provider owns token refresh and storage.
          const credential = await api.integration.connection.resolve(connection)
          if (credential?.type !== "oauth") return inactive
          const result = await fetchUsage(credential.access, accountID(credential.access, credential.metadata), context.signal)
          const current = await api.integration.connection.active("openai")
          return current?.type === "credential" && current.id === credentialID ? result : inactive
        } catch {
          // Never send raw credential, provider, or network errors to the client.
          return unavailable("Unable to resolve the ChatGPT account. Check OpenAI in /connect.")
        }
      },
    })
  },
} satisfies Plugin.Plugin
