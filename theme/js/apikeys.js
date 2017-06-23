(function () {
  var placeholder = 'your-mapzen-api-key';
  var el = document.querySelector('.documentation-content');
  if (!el) return;

  // Polyfill isArray
  if (!Array.isArray) {
    Array.isArray = function(arg) {
      return Object.prototype.toString.call(arg) === '[object Array]';
    };
  }

  // Use fetch if we have it; otherwise use XHR until fetch is polyfilled for old browsers
  if (window.fetch) {
    window.fetch('/api/keys.json', { credentials: 'same-origin' })
      .then(function (response) {
        return response.json();
      })
      .then(processKeys)
      .catch(function (err) {
        console.error('Error fetching user API keys: ', err);
      });
  } else {
    var request = new XMLHttpRequest();

    request.open('GET', '/api/keys.json');
    request.onerror = function (err) {
      throwError(err);
    };
    request.onreadystatechange = function () {
      if (request.readyState === 4) {
        if (request.status === 200 || request.status === 304) {
          try {
            var response = JSON.parse(request.responseText);
            processKeys(response);
          } catch (err) {
            throwError(err);
          }
        } else {
          throwError(request.status);
        }
      }
    };
    request.send();
  }

  function throwError(err) {
    console.error('Error fetching user API keys: ', err);
  }

  function processKeys(data) {
    // Silent fail if data is not an array, or is zero-length
    if (!Array.isArray(data) || data.length === 0) return;
    searchAndReplaceWithKey(el, data[0].key);
  }

  function searchAndReplaceWithKey(el, key) {
    var regex = new RegExp(placeholder, 'g');
    el.innerHTML = el.innerHTML.replace(regex, key);
  }

  // document.querySelector('.documentation-content').innerHTML = document.querySelector('.documentation-content').innerHTML.replace(/[{[]?your[_-]mapzen[_-]api[_-]key[}\]]?/gi, 'hihihih-2302323');

})();
