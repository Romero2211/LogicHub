import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "empty", "preview", "image", "name"]

  connect() {
    this.objectUrl = null
    if (this.inputTarget.files?.[0]) this.showFile(this.inputTarget.files[0])
  }

  disconnect() {
    this.revoke()
  }

  change() {
    const file = this.inputTarget.files?.[0]
    file ? this.showFile(file) : this.resetPreview()
  }

  dragover(event) {
    event.preventDefault()
    this.emptyTarget.classList.add("border-[#7c3aed]")
  }

  dragleave() {
    this.emptyTarget.classList.remove("border-[#7c3aed]")
  }

  drop(event) {
    event.preventDefault()
    this.emptyTarget.classList.remove("border-[#7c3aed]")

    const file = event.dataTransfer.files?.[0]
    if (!file || !file.type.startsWith("image/")) return

    const transfer = new DataTransfer()
    transfer.items.add(file)
    this.inputTarget.files = transfer.files
    this.showFile(file)
  }

  clear(event) {
    event.preventDefault()
    this.inputTarget.value = ""
    this.resetPreview()
  }

  showFile(file) {
    this.revoke()
    this.objectUrl = URL.createObjectURL(file)
    this.imageTarget.src = this.objectUrl
    this.nameTarget.textContent = `${file.name} · ${this.fileSize(file.size)}`
    this.emptyTarget.classList.add("hidden")
    this.previewTarget.classList.remove("hidden")
  }

  resetPreview() {
    this.revoke()
    this.imageTarget.removeAttribute("src")
    this.nameTarget.textContent = ""
    this.previewTarget.classList.add("hidden")
    this.emptyTarget.classList.remove("hidden")
  }

  revoke() {
    if (this.objectUrl) {
      URL.revokeObjectURL(this.objectUrl)
      this.objectUrl = null
    }
  }

  fileSize(bytes) {
    if (bytes < 1024) return `${bytes} Б`
    if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(1)} КБ`
    return `${(bytes / (1024 * 1024)).toFixed(1)} МБ`
  }
}
