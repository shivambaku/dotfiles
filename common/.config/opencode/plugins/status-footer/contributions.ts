import type { EventEmitter } from "node:events"

// CliRenderer is an EventEmitter shared by the plugins in one terminal client.
// Namespaced events avoid global/persistent state and work across plugin reloads.
const UPDATE = "dotfiles.status-footer.update"
const COLLECT = "dotfiles.status-footer.collect"
export const FOOTER_SEPARATOR = " · "

export interface FooterValue {
  sessionID: string
  items: readonly string[]
}

interface Contribution {
  id: string
  order: number
  owner: symbol
  value?: FooterValue
}

export function contributeFooter(renderer: EventEmitter, id: string, order = 50) {
  const item: Contribution = { id, order, owner: Symbol(id) }
  let disposed = false
  const publish = () => renderer.emit(UPDATE, { ...item })
  renderer.on(COLLECT, publish)
  return {
    update(value?: FooterValue) {
      if (disposed) return
      item.value = value
      publish()
    },
    dispose() {
      if (disposed) return
      disposed = true
      renderer.off(COLLECT, publish)
      item.value = undefined
      publish()
    },
  }
}

export function observeFooter(renderer: EventEmitter, receive: (values: readonly FooterValue[]) => void) {
  const items = new Map<string, Contribution>()
  const update = (item: Contribution) => {
    if (item.value) items.set(item.id, item)
    else if (items.get(item.id)?.owner === item.owner) items.delete(item.id)
    receive([...items.values()]
      .sort((a, b) => a.order - b.order || a.id.localeCompare(b.id))
      .map((entry) => entry.value!))
  }
  renderer.on(UPDATE, update)
  renderer.emit(COLLECT)
  return () => renderer.off(UPDATE, update)
}

export function footerText(items: readonly (string | undefined)[]): string {
  return items.map((item) => item?.replace(/[\u0000-\u001f\u007f-\u009f]/g, " ").trim())
    .filter(Boolean).join(FOOTER_SEPARATOR)
}
