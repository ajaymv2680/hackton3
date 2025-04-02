import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    window.addEventListener("storage", this.sync.bind(this));
  }

  disconnect() {
    window.removeEventListener("storage", this.sync.bind(this));
  }

  sync(event) {
    if (event.key === "task_updated") {
      // Reload the tasks section to reflect the latest state
      Turbo.visit(window.location.href, { action: "replace" });
    }
  }
}