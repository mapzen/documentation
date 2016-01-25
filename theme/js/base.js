
function getSearchTerm()
{
    var sPageURL = window.location.search.substring(1);
    var sURLVariables = sPageURL.split('&');
    for (var i = 0; i < sURLVariables.length; i++)
    {
        var sParameterName = sURLVariables[i].split('=');
        if (sParameterName[0] == 'q')
        {
            return sParameterName[1];
        }
    }
}

$(document).ready(function () {
  var search_term = getSearchTerm()
  var $search_modal = $('#mkdocs_search_modal')
  var $searchResults = $('#mkdocs-search-results')
  var $searchInput = $('#mkdocs-search-query')

  if (search_term) {
    $searchInput.val(search_term)
  }

  var selectedPosition

  $searchInput.on('keyup', function (e) {
    // Need to wait a bit for search function to finish populating our results
    setTimeout(function () {
      // See if anything is inside the search results
      if ($.trim($searchResults.html()) !== '') {
        $searchResults.show()
        $searchResults.css('max-height', window.innerHeight - $searchResults[0].getBoundingClientRect().top - 100)

        var input = $searchInput.val().trim()
        var list = $searchResults.find('article')

        if (list.length > 0) {
          // var highlight = function (text, focus) {
          //   var r = RegExp('(' + focus + ')', 'gi');
          //   return text.replace(r, '<strong>$1</strong>');
          // }

          // var html = $searchResults.html()
          // $searchResults.html(highlight(html, input))

          // Now reapply selection
          if (selectedPosition) {
            list[selectedPosition].addClass('selected')
          }
        }
      } else {
        $searchResults.hide()
      }
    }, 0)
  })

  $search_modal.on('blur', function () {
    resetSearchResults();
  })
  $searchResults.on('click', 'article', function (e) {
    findAndOpenLink(this);
    // In case it just jumps down the page
    resetSearchResults();
  })

  function findAndOpenLink (articleEl) {
    var link = $(articleEl).find('a').attr('href')
    window.location.href = link;
  }

  function resetSearchResults () {
    $searchResults.empty();
    $searchResults.hide();
  }

  // Highlight.js
  hljs.initHighlightingOnLoad();
});

// Add the correct class to tables
$('table').addClass('table');

/* Prevent disabled links from causing a page reload */
$('li.disabled a').click(function(event) {
  event.preventDefault();
})
