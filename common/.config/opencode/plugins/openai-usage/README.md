# OpenAI plan usage

OpenCode V2 server/TUI plugin for ChatGPT subscription limits. The footer shows
remaining percentages and reset countdowns for the windows returned by OpenAI.
`/openai-usage` opens a dialog with progress bars, local reset times, and the last
successful update time. Refreshes once per minute and on account switches.

The footer is limited to sessions using the OpenAI integration. Other providers,
environment connections, and API-key accounts do not display a subscription meter.
The provider-independent `status-footer` plugin supplies the account label and
formats the footer. This plugin publishes quota items through its generic
renderer-local contribution interface; the footer never calls OpenAI.

The server resolves the active OAuth connection through OpenCode and requests
`https://chatgpt.com/backend-api/wham/usage`. This is an internal ChatGPT endpoint;
unexpected responses are displayed as unavailable. Credentials stay on the server,
and quota snapshots are kept only in memory. No model calls are made.

OpenCode automatically discovers the server plugin under
`~/.config/opencode/plugins/openai-usage/`; no `opencode.json` entry is needed.
These dotfiles explicitly register the TUI in `cli.json`. The plain server export
and RPC definition use type-only SDK imports so local plugins need no installed
server SDK at runtime. The TUI imports are supplied by OpenCode.
