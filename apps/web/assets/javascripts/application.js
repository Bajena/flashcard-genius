(function wordListForm() {
  if (!document.getElementById('word-list-form')) {
    return;
  }

  var template = document.getElementById('word-form-template');
  template.remove();

  document.getElementById('add-new-word-button').onclick = function() {
    var words = document.getElementsByClassName('word-form');
    var newIndex = parseInt(words[words.length - 1].dataset.index || -1) + 1;

    var wordFormsDiv = document.getElementById('word-forms');
    var newTemplate = template.cloneNode(true);
    newTemplate.dataset.index = newIndex;
    wordFormsDiv.insertAdjacentHTML('beforeend', newTemplate.outerHTML.replace(/words\-0/g, "words-" + newIndex));
  }
})();
