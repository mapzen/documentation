(function () {
  var placeholder = 'your-mapzen-api-key';
  var el = document.querySelector('.documentation-content');
  if (!el) return;

  window.fetch('/api/keys.json', { credentials: 'same-origin' })
    .then(function (response) {
      return response.json();
    })
    .then(function (data) {
      // Silent fail if data is not an array, or is zero-length
      if (!Array.isArray(data) || data.length === 0) return;
      searchAndReplaceWithKey(el, data[0].key);
    })
    .catch(function (err) {
      console.error('Error fetching user API keys: ', err);
    });

  function searchAndReplaceWithKey(el, key) {
    var regex = new RegExp(placeholder, 'g');
    el.innerHTML = el.innerHTML.replace(regex, key);
  }

  // document.querySelector('.documentation-content').innerHTML = document.querySelector('.documentation-content').innerHTML.replace(/[{[]?your[_-]mapzen[_-]api[_-]key[}\]]?/gi, 'hihihih-2302323');

})();
