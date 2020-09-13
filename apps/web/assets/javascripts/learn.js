(function learn() {
  if (!document.getElementById('learn')) {
    return;
  }

  var wordContainer = document.getElementById('learn-word-container');
  var nextWordPath = wordContainer.dataset.loadPath;
  var sendResultPath = wordContainer.dataset.sendResultPath;

  function sendResult(form) {
    return fetch(form.action, {
      method: form.method,
      body: new FormData(form)
    })
    .then(function() { loadNextWord(); })
    .catch(function(err) {
      console.log('Failed to send result: ', err);
    });
  }

  function loadNextWord() {
    wordContainer.innerHTML = "Loading a word..."
    fetch(nextWordPath)
      .then(function(response) {
        return response.text()
      })
      .then(function(html) {
        wordContainer.innerHTML = html;
        var responseForms = wordContainer.querySelectorAll('.send-result-form');
        responseForms.forEach(function(form) {
          form.addEventListener( "submit", function ( event ) {
            event.preventDefault();

            sendResult(form);
          });
        });
      })
      .catch(function(err) {
          console.log('Failed to fetch page: ', err);
      });
  }

  loadNextWord();
})();
