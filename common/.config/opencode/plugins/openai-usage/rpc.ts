import type { Rpc } from "@opencode/plugin/rpc"

export const OpenAIUsage = {
  id: "dotfiles.openai-usage",
  events: {},
  methods: {
    read: {
      input: {
        type: "object",
        properties: { credentialID: { type: "string" } },
        required: ["credentialID"],
        additionalProperties: false,
      },
      output: {
        type: "object",
        properties: {
          status: { type: "string", enum: ["ready", "inactive", "unavailable"] },
          plan: { type: "string" },
          updatedAt: { type: "number" },
          message: { type: "string" },
          windows: {
            type: "array",
            items: {
              type: "object",
              properties: {
                seconds: { type: "number", exclusiveMinimum: 0 },
                remaining: { type: "number", minimum: 0, maximum: 100 },
                resetsAt: { type: "number" },
              },
              required: ["seconds", "remaining", "resetsAt"],
              additionalProperties: false,
            },
          },
        },
        required: ["status", "windows"],
        additionalProperties: false,
      },
    },
  },
} as const satisfies Rpc.PortableDefinition
