// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

let preservedScroll = null

function restoreScroll() {
  if (preservedScroll == null) return

  const y = preservedScroll
  window.scrollTo(0, y)
  requestAnimationFrame(() => window.scrollTo(0, y))
}

document.addEventListener("turbo:submit-start", (event) => {
  if (event.target.closest("[data-preserve-scroll]")) {
    preservedScroll = window.scrollY
  }
})

document.addEventListener("turbo:before-fetch-request", (event) => {
  const source = event.target
  if (source?.closest?.("[data-preserve-scroll]") || source?.id === "posts_feed" || source?.id === "comments_feed") {
    preservedScroll = window.scrollY
  }
})

document.addEventListener("turbo:before-stream-render", restoreScroll)
document.addEventListener("turbo:submit-end", restoreScroll)
document.addEventListener("turbo:frame-render", restoreScroll)
document.addEventListener("turbo:render", restoreScroll)
