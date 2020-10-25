(function() {
  if (!document.getElementById('word-list-show')) { return; }

  function onEditClick(button) {
    var card = button.closest(".flashcard-column");
    card.querySelector(".flashcard-content").classList.add("hidden");
    card.querySelector(".edit-word-form").classList.remove("hidden");
  }

  function onCancelClick(button) {
    var card = button.closest(".flashcard-column");
    card.querySelector(".flashcard-content").classList.remove("hidden");
    card.querySelector(".edit-word-form").classList.add("hidden");
  }

  function updateCompleteHandler(event) {
    var form = event.target;
    if (!form.className.includes("edit-word-form")) {
      return;
    }

    var status = event.detail.status;

    if (status >= 200 && status < 300) {
      alertify.success("Word updated");
      var card = form.closest(".flashcard-column");
      card.outerHTML = event.detail.response;

      // The old node got completely replaced. We need to find it again.
      var newCard = document.querySelector("[data-word-id='" + card.dataset.wordId + "']");
      newCard.scrollIntoView();
    } else {
      alertify.error("Update failed");
      var saveButton = form.getElementsByClassName("edit-save-button")[0];

      saveButton.disabled = false;
      saveButton.innerText = "Save"
    }
  }

  document.addEventListener("click", function(e) {
    if (e.target.className.includes("edit-word-button")) {
      return onEditClick(e.target);
    }

    if (e.target.className.includes("cancel-edit-button")) {
      return onCancelClick(e.target);
    }
  });

  document.addEventListener("ajax:complete", updateCompleteHandler);
})();
