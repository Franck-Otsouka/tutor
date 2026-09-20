import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["startTime", "endTimePreview"]

  updateEndTime() {
    const startValue = this.startTimeTarget.value

    if (!startValue) {
      this.endTimePreviewTarget.textContent = ""
      return
    }

    const duration = Number(this.element.dataset.duration)

    if (!duration) {
      this.endTimePreviewTarget.textContent = ""
      return
    }

    const startTime = new Date(startValue)

    if (Number.isNaN(startTime.getTime())) {
      this.endTimePreviewTarget.textContent = ""
      return
    }

    const endTime = new Date(
      startTime.getTime() + duration * 60 * 1000
    )

    const formatted = endTime.toLocaleString([], {
      weekday: "short",
      day: "numeric",
      month: "short",
      hour: "2-digit",
      minute: "2-digit"
    })

    this.endTimePreviewTarget.textContent =
      `Expected end time: ${formatted}`
  }
}
