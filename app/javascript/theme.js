// Light/dark/auto theme switcher.
// Initial paint is handled by an inline <head> script in the layout so the
// page never flashes the wrong theme. This module wires the navbar dropdown
// and keeps "auto" in sync with the OS preference.

const STORAGE_KEY = "theme"

function getStoredTheme() {
  try { return localStorage.getItem(STORAGE_KEY) || "auto" }
  catch (e) { return "auto" }
}

function setStoredTheme(theme) {
  try { localStorage.setItem(STORAGE_KEY, theme) }
  catch (e) { /* localStorage blocked; in-memory only */ }
}

function resolveTheme(theme) {
  if (theme === "auto") {
    return window.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light"
  }
  return theme
}

function applyTheme(theme) {
  document.documentElement.setAttribute("data-bs-theme", resolveTheme(theme))

  document.querySelectorAll("[data-bs-theme-value]").forEach((btn) => {
    btn.classList.toggle("active", btn.getAttribute("data-bs-theme-value") === theme)
  })

  const icon = document.getElementById("theme-toggle-icon")
  if (icon) {
    icon.className =
      theme === "light" ? "fa-solid fa-sun" :
      theme === "dark"  ? "fa-solid fa-moon" :
                          "fa-solid fa-circle-half-stroke"
  }
}

function initThemeToggle() {
  applyTheme(getStoredTheme())

  document.querySelectorAll("[data-bs-theme-value]").forEach((btn) => {
    btn.addEventListener("click", () => {
      const theme = btn.getAttribute("data-bs-theme-value")
      setStoredTheme(theme)
      applyTheme(theme)
    })
  })
}

// Re-track OS changes so "auto" stays accurate without a reload.
window.matchMedia("(prefers-color-scheme: dark)").addEventListener("change", () => {
  if (getStoredTheme() === "auto") applyTheme("auto")
})

document.addEventListener("turbo:load", initThemeToggle)
