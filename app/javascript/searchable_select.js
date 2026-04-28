// Wraps any <select class="js-searchable-select"> with TomSelect so users can
// type to filter long option lists (projects, accounts, payment methods).
import TomSelect from "tom-select"

const INSTANCES = new WeakMap()

function init() {
  document.querySelectorAll("select.js-searchable-select").forEach((el) => {
    if (INSTANCES.has(el) || el.tomselect) return

    const allowCreate = el.dataset.allowCreate === "true"

    const ts = new TomSelect(el, {
      allowEmptyOption: true,
      maxOptions: null,
      create: allowCreate,
      plugins: ["clear_button"],
    })
    INSTANCES.set(el, ts)
  })
}

document.addEventListener("turbo:load", init)
document.addEventListener("turbo:render", init)
