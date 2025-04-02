import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["form", "title", "description", "error"];

  toggle(event) {
    event.preventDefault();
    this.formTarget.classList.toggle("hidden");
  }

  closeModal() {
    console.log("Closing modal");
    this.element.remove();
  }

  validate(event) {
    this.errorTarget.innerHTML = "";

    if (this.titleTarget.value.trim() === "") {
      this.errorTarget.innerHTML += "<p>Title is required.</p>";
      event.preventDefault();
    }

    if (this.descriptionTarget.value.trim() === "") {
      this.errorTarget.innerHTML += "<p>Description is required.</p>";
      event.preventDefault();
    }
  }
}