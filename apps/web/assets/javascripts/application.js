(function wordListForm() {
  if (!document.getElementById('word-list-form')) {
    return;
  }

  var formTemplate;

  function setupRemoveButton(btn) {
    btn.onclick = function() {
      if (document.getElementsByClassName('word-form').length === 1) {
        return;
      }

      this.closest('.word-form').remove();
    }
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

    var firstTextBox = newlyInsertedForm.querySelector('input');
    firstTextBox.focus();
    firstTextBox.scrollIntoView();
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
      }
    });
  }

  setupNewWordTemplate();
  setupRemoveButtons();
  setupKeyboardShortcuts();
})();
