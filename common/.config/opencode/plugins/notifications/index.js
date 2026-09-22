import { execFile } from "node:child_process"
import { promisify } from "node:util"

const run = promisify(execFile)

export default {
    id: "dotfiles.notifications",
    setup(ctx) {
        const controller = new AbortController()
        const notify = async () => {
            const options = { signal: controller.signal, timeout: 10000 }
            if (process.platform === "darwin") {
                await run("osascript", ["-e", 'display notification "Session completed!" with title "opencode"'], options)
            } else if (process.platform === "linux") {
                await run("notify-send", ["--app-name=opencode", "opencode", "Session completed!"], options)
            }
        }

        void (async () => {
            for await (const event of ctx.event.subscribe({ signal: controller.signal })) {
                if (event.type !== "session.idle") continue
                // Each location has a plugin instance, but the event stream is server-wide.
                if (event.location?.directory !== ctx.location.directory) continue
                void notify().catch((error) => {
                    if (!controller.signal.aborted) console.error("Desktop notification failed", error)
                })
            }
        })().catch((error) => {
            if (!controller.signal.aborted) console.error("Notification subscription failed", error)
        })

        return () => controller.abort()
    },
}
