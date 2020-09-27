(function() {
  if (!document.getElementById('word-list-show')) { return; }

  var ajaxCompleteHandler = function(event) {
    var btn = event.target;
    if (!btn.className.includes("delete-word-form")) {
      return;
    }

    var status = event.detail.status;

    if (status >= 200 && status < 300) {
      btn.closest(".flashcard-column").remove();
    } else {
      console.error("Failed to delete word");
    }
  };

  document.addEventListener("ajax:complete", ajaxCompleteHandler);
})();
