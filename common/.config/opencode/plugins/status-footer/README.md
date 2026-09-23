# Status footer

Provider-independent replacement for OpenCode's `opencode.prompt.footer` plugin.
It displays active subagent/shell counts, the account label, contributed status
items, context usage, and API cost when present. Visible items use one separator:
` · `. The command-palette hint is omitted; Ctrl+P still opens the palette.
The native activity indicator, project location, and file status remain in their
own footer slots. Shell mode keeps the `esc exit shell mode` hint.
Clicking the subagent/shell counters opens the session's child activity; the
account, quota, and context items are non-clickable.

`cli.json` disables `opencode.prompt.footer` and loads this package. Context usage
matches OpenCode V2's latest assistant token report, respecting compaction and
undo boundaries. The row truncates rather than wrapping on narrow terminals.

## Contributions

Other TUI plugins can import `contributeFooter` from `./contributions` and register
an item on their `api.renderer`. For example:

```ts
const item = contributeFooter(api.renderer, "my-plugin", 50)
item.update({ sessionID, items: ["Some status", "Another detail"] })
item.update() // Hide this contribution.
item.dispose() // Call on plugin/component cleanup.
```

The interface uses namespaced events on OpenTUI's renderer EventEmitter, which is
shared within one TUI. Contributions are session-scoped, ordered by priority then
ID, and held only in memory. A renderer that mounts later requests current values
from publishers. Cleanup and plugin reloads remove only the owning contribution.
The footer has no dependency on provider-specific plugins or endpoints.
