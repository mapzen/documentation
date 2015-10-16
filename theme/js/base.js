
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
  var $searchResults = $('#mkdocs-search-results')
  var $searchInput = $('#mkdocs-search-query')
  var $nav = $('nav')
  var $toc = $('#toc')
  var $docContent = $('.documentation-content').parent()
  var affixState = false

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
  /* DISABLED, this doesn't work well because other search JS overwrites selection
  $searchInput.on('keydown', function (e) {
    // Ignore key results are not visible
    if (!$searchResults.is(':visible')) {
      return;
    }

    var selected = $searchResults.find('article.selected')[0]
    var list = $searchResults.find('article')

    for (var i = 0; i < list.length; i++) {
      if (list[i] === selected) {
        selectedPosition = i;
        break;
      }
    }

    switch (e.keyCode) {
      // 13 = enter
      case 13:
        e.preventDefault()
        if (selected) {
          findAndOpenLink(selected)
        }
        break;
      // 38 = up arrow
      case 38:
        e.preventDefault()

        if (selected) {
          $(selected).removeClass('selected')
        }

        var previousItem = list[selectedPosition - 1];

        if (selected && previousItem) {
          $(previousItem).addClass('selected');
        } else {
          $(list[list.length - 1]).addClass('selected');
        }
        break;
      // 40 = down arrow
      case 40:
        e.preventDefault()

        if (selected) {
          $(selected).removeClass('selected');
        }

        var nextItem = list[selectedPosition + 1];

        if (selected && nextItem) {
          $(nextItem).addClass('selected');
        } else {
          $(list[0]).addClass('selected');
        }
        break;
      // all other keys
      default:
        break;
    }
  })
  */
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
  $('table').addClass('table');

  // Affix for side nav bar
  // Don't turn on affix if the TOC height is greater than
  // document content, to prevent positioning bugs
  if ($toc.height() < $docContent.height()) {
    $toc.affix({
      offset: {
        top: function () {
          return $docContainer.offset().top - $nav.height()
        },
        bottom: function () {
            return $(document).height() - $docContainer.offset().top - $docContainer.outerHeight(true)
        }
      }
    })
    // Record that affix is on
    affixState = true
  }

  $('.toc-subnav-toggle').on('click', function (e) {
    e.preventDefault()
    var $el = $(this).next('ul')
    $el.toggleClass('toc-expand')

    // Recalc affix position after expand transition finishes
    if (affixState === true) {
      $el.one('webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend', function (e) {
        $toc.affix('checkPosition')
      })
    }
  })

  // Guarantee only one active thing is up

  var activeEls = $('.toc li.active')
  activeEls.each(function (index) {
    if (index + 1 !== activeEls.length) {
      $(activeEls[index]).removeClass('active')
    }
  })

  // Wrap all tables in a wrapper div
  $('.table').wrap('<div class="table-wrapper"></div>');
});


$('body').scrollspy({
  target: '.toc',
  offset: 10
});

/* Prevent disabled links from causing a page reload */
$('li.disabled a').click(function(event) {
  event.preventDefault();
})
