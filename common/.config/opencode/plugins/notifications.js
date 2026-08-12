export const NotificationPlugin = async ({ project, client, $, directory, worktree }) => {
    return {
        event: async ({ event }) => {
            if (event.type === "session.idle") {
                if (process.platform === "darwin") {
                    await $`osascript -e 'display notification "Session completed!" with title "opencode"'`
                } else if (process.platform === "linux") {
                    await $`notify-send --app-name=opencode "opencode" "Session completed!"`
                }
            }
        },
    }
}
