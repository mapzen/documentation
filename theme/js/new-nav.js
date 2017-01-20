
  var toggleNewEls = document.querySelectorAll('.toc-list-toggle');
  for (var i = 0, j = toggleNewEls.length; i < j; i++) {
    var toggle = toggleNewEls[i];
    toggle.addEventListener('click', function (e) {
      // Expands the submenu if there is no link to another page
      // e.target.href expands to a fully qualified URL; don't use it
       // if (!e.currentTarget.href || e.currentTarget.getAttribute('href') === '#') {

        var sublist = e.currentTarget.nextElementSibling;
        sublist.classList.toggle('toc-expand');

        var carretEl = e.currentTarget.getElementsByTagName('i')[0];
        carretEl.classList.toggle('fa-angle-right');
        carretEl.classList.toggle('fa-angle-down');
        //}

        // Recalc affix position after expand transition finishes
        // if (affixState === true) {
        //   $(sublist).one('webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend', function (e) {
        //     $el.affix('checkPosition');
        //   });
        // }
      //}
    });
  }