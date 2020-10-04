(function() {
  var quickAddWordForm = document.getElementById('quick-add-word-form');

  if (!quickAddWordForm) { return; }

  function show(el) {
    el.style.display = "block"
  }

  function isVisible(el) {
    return el.style.display != "none"
  }

  function hide(el) {
    el.style.display = "none"
  }

  function showErrors(html) {
    errorsContainer.innerHTML = html;
    show(errorsContainer);
  }

  var addButton = document.getElementById('add-word-button');
  var quickAddWordWrapper = document.getElementById('quick-add-word-wrapper');
  hide(quickAddWordWrapper);

  addButton.onclick = function() {
    if (isVisible(quickAddWordWrapper)) {
      hide(quickAddWordWrapper);
      addButton.innerText = "Add a word";
    } else {
      show(quickAddWordWrapper);
      addButton.innerText = "Hide new word form";
    }
  }

  var errorsContainer = document.getElementById('quick-add-word-form-errors');
  hide(errorsContainer);

  var ajaxBeforeHandler = function(event) {
    errorsContainer.innerHTML = "";
    hide(errorsContainer);
  };

  var ajaxCompleteHandler = function(event) {
    var status = event.detail.status;
    if (status >= 200 && status < 300) {
      document.getElementById('words-listing').insertAdjacentHTML('beforeend', event.detail.response);
      quickAddWordForm.reset();
      alertify.success("Word added");
    } else if (status == 422) {
      showErrors(event.detail.response);
    } else {
      showErrors('Unknown error occured');
    }

    var submitButton = document.querySelector('#submit-word-button');
    submitButton.disabled = false;
    submitButton.innerText = submitButton.dataset.originalText;
  };

  quickAddWordForm.addEventListener("ajax:before", ajaxBeforeHandler);
  quickAddWordForm.addEventListener("ajax:complete", ajaxCompleteHandler);
})();
