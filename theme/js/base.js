
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
  var $docContainer = $('.documentation-container')
  var $nav = $('nav')

  if (search_term) {
    $('#mkdocs-search-query').val(search_term)
  }

  // Autofocus to search.
  $('#mkdocs-search-query').focus()

  // Highlight.js
  hljs.initHighlightingOnLoad();
  $('table').addClass('table table-striped table-hover');

  // Affix for side nav bar
  $('#toc').affix({
    offset: {
      top: function () {
        // Calculate the top offset
        return $docContainer.offset().top - $nav.height()
      },
      bottom: function () {
        return $(document).height() - $docContainer.offset().top - $docContainer.outerHeight(true)
      }
    }
  })

  $('.toc-subnav-toggle').on('click', function (e) {
    e.preventDefault()
    $(this).next('ul').toggleClass('toc-expand')
  })
});


$('body').scrollspy({
  target: '.toc-sidenav',
});

/* Prevent disabled links from causing a page reload */
$('li.disabled a').click(function(event) {
  event.preventDefault();
})
