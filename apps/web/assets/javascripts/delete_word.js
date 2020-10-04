(function() {
  if (!document.getElementById('word-list-show')) { return; }

  var ajaxCompleteHandler = function(event) {
    var form = event.target;
    if (!form.className.includes("delete-word-form")) {
      return;
    }

    var status = event.detail.status;

    if (status >= 200 && status < 300) {
      form.closest(".flashcard-column").remove();
    } else {
      alertify.error("Deleting word failed");
      form.getElementsByTagName("button")[0].disabled = false;
    }
  };

  document.addEventListener("ajax:complete", ajaxCompleteHandler);
})();
