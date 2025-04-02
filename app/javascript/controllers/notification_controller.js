import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    console.log("Notification controller connected");
    setTimeout(() => {
      this.element.remove();
    }, 5000);
  }
}