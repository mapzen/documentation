;(function () {
  'use strict'
  // Replace stock valhalla home page
  if (document.body.className.indexOf('homepage') >= 0) {
    document.getElementsByClassName('documentation-content')[0].innerHTML = '<a href="./elevation-service/">Click here to continue to Elevation Service documentation.</a>'
    document.getElementsByClassName('documentation-edit')[0].innerHTML = ''
  }
  // Remove 'home' link from TOC
  var tocListEl = document.getElementsByClassName('toc-nav')[0]
  tocListEl.removeChild(tocListEl.getElementsByClassName('toc-top-level')[0])
  // Remove one level of breadcrumb nav
  var breadcrumbsEl = document.getElementsByClassName('breadcrumb')[0]
  breadcrumbsEl.removeChild(breadcrumbsEl.children[1])
})()