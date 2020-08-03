(function wordListForm() {
  if (!document.getElementById('word-list-form')) {
    return;
  }

  var formTemplate;

  function isOnlyOneWordLeft() {
    return document.getElementsByClassName('word-form').length <= 1
  }

  function setupRemoveButton(btn) {
    btn.onclick = function() {
      if (isOnlyOneWordLeft()) {
        return;
      }

      this.closest('.word-form').remove();
    }
  }

  function focusTextBox(wordForm) {
    var firstTextBox = wordForm.querySelector('input');
    firstTextBox.focus();
    firstTextBox.scrollIntoView();
  }

  function addNewWordForm() {
    var words = document.getElementsByClassName('word-form');
    var lastWord = words[words.length - 1];
    var newIndex = (lastWord ? parseInt(lastWord.dataset.index) : -1) + 1;

    var wordFormsDiv = document.getElementById('word-forms');
    var newTemplate = formTemplate.cloneNode(true);
    newTemplate.dataset.index = newIndex;
    var newFormHtml = newTemplate.outerHTML.replace(/words\-0/g, "words-" + newIndex);
    wordFormsDiv.insertAdjacentHTML('beforeend', newFormHtml);

    var newlyInsertedForm = wordFormsDiv.lastChild;
    setupRemoveButton(newlyInsertedForm.querySelector('.remove-word-button'));

    focusTextBox(newlyInsertedForm);
  }

  function setupNewWordTemplate() {
    formTemplate = document.getElementById('word-form-template');
    formTemplate.classList.remove('word-form-template');
    formTemplate.remove();

    document.getElementById('add-new-word-button').onclick = addNewWordForm;
  }

  function setupRemoveButtons() {
    var removeBtns = document.getElementsByClassName('remove-word-button');

    for (var i = 0; i < removeBtns.length; i++) {
      setupRemoveButton(removeBtns[i]);
    }
  }

  function setupKeyboardShortcuts() {
    window.addEventListener('keydown', function(event) {
      if ((event.metaKey || event.ctrlKey) && event.key === 'Enter') {
        addNewWordForm();
        event.stopPropagation();
        event.preventDefault();
        return;
      }

      if ((event.metaKey || event.ctrlKey) && event.key === 'Backspace') {
        if (isOnlyOneWordLeft()) { return; }
        if (!document.activeElement) { return; }

        var word = document.activeElement.closest('.word-form');
        if (!word) { return; }

        word.remove();
        var words = document.getElementsByClassName('word-form');
        focusTextBox(words[words.length - 1]);

        event.stopPropagation();
        event.preventDefault();
        return;
      }
    });
  }

  setupNewWordTemplate();
  setupRemoveButtons();
  setupKeyboardShortcuts();
})();
