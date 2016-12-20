<script>
function elementIntersectsViewport (el) {
  var top = el.offsetTop;
  var height = el.offsetHeight;

  while(el.offsetParent) {
    el = el.offsetParent;
    top += el.offsetTop;
  }

  return (
    top < (window.pageYOffset + window.innerHeight) &&
    (top + height) > window.pageYOffset
  );
}

function hide(el) {
    iframe = el.getElementsByTagName("iframe")[0];
    if (typeof iframe != "undefined") {
        try {
            if (typeof iframe.contentWindow.scene != 'undefined') {
                // make a new blob from the codemirror code
                var blob = new Blob([iframe.contentWindow.editor.getValue()], {type: "text/plain"});
                // make an objectURL from the blob and save that to the parent div
                el.setAttribute("code", window.URL.createObjectURL(blob));
                // console.log('saved', el.getAttribute("code"))
                el.removeChild(iframe);
            }
        }
        catch(e) {
            console.log(e);
            el.removeChild(iframe);
        }
    }
}
function show(el) {
    if (typeof el != 'undefined') {
        iframe = el.getElementsByTagName("iframe")[0];
        if (typeof iframe == "undefined") {

            // create a new iframe
            iframe = document.createElement("iframe");
            var source = '';
            el.appendChild(iframe);
            iframe.style.height = "100%";

            // get the source if it has been set
            if (typeof el.getAttribute("source") != 'undefined') {
                // get the source
                source = el.getAttribute("source");
                if (el.getAttribute("code") !='' && el.getAttribute("code") !='null') {
                    // get source from the previously-saved blobURL
                    var code = el.getAttribute("code");
                    iframe.src = replaceUrlParam(el.getAttribute("source"), "scene", code);
                } else {
                    iframe.src = source;
                }
            }
        }
    }
}

function replaceUrlParam(url, paramName, paramValue){
    // from http://stackoverflow.com/questions/7171099/how-to-replace-url-parameter-with-javascript-jquery
    if(paramValue == null)
        paramValue = '';
    var pattern = new RegExp('\\b('+paramName+'=).*?(&|$)')
    if(url.search(pattern)>=0){
        return url.replace(pattern,'$1' + paramValue + '$2');
    }
    return url + (url.indexOf('?')>0 ? '&' : '?') + paramName + '=' + paramValue 
}


// check visibility every half-second, hide off-screen demos to go easy on the GPU
setInterval( function() {
    var elements = document.getElementsByClassName("demo-wrapper");
    for (var i=0; i < elements.length; i++) {
        el = elements[i];
        if (elementIntersectsViewport(el) || (i == 0 && window.pageYOffset < 500)) {
            show(el);
            // show the next two iframes as well
            show(elements[i+1]);
            show(elements[i+2]);
            for (var j=0; j < elements.length; j++) {
                // don't hide the previous one, the current one, or the next two
                if (j != i && j != i-1 && j != i+1 && j != i+2) {
                    hide(elements[j]);
                }
            }
            break;
        }
    }
}, 500);
</script>
<style>
.demo-wrapper {
    margin-bottom: 1em;
}
</style>

Mapzen has published a number of stylish yet functional [basemaps](https://mapzen.com/products/maps/), equally suitable for the home or office. They can be used as standalone Leaflet layers using [Mapzen.js](https://mapzen.com/documentation/mapzen-js/):

```javascript
var map = L.Mapzen.map('map', {
  center: [40.74429, -73.99035],
  zoom: 15,
  scene: L.Mapzen.BasemapStyles.Refill
})
```

Or, you can use [Tangram](https://mapzen.com/products/tangram/) to put your own data on top of them with the `import` feature:

<div class="demo-wrapper" id="demo0" code="" source="https://precog.mapzen.com/tangrams/tangram-play/master/embed/?go=👌&scene=https://tangrams.github.io/tangram-docs/tutorials/editing-basemaps/editing-basemaps1.yaml#16.50417/40.78070/-73.96085"></div>

But what do you do if you want to modify the house style? This is a bit trickier, and involves a bit of detective work.

First, you must know what feature you want to modify. The broader the class of features you want to change, the trickier it will be to change them. In our house styles, a given feature may be affected by multiple styles and sets of drawing rules, specifying a slightly different style at various zoom levels, and for various sub-classifications of the data. So, once you've picked a feature, you must understand how that feature is currently drawn.

# simple example

Before we start pulling apart a house style, let's start with a simpler example. Here's a very basic Tangram scene file:

<div class="demo-wrapper" id="demo0" code="" source="https://precog.mapzen.com/tangrams/tangram-play/master/embed/?go=👌&scene=https://tangrams.github.io/tangram-docs/tutorials/editing-basemaps/simple-basemap.yaml#16.50417/40.78070/-73.96085"></div>

We've saved this scene file to the Tangram documentation repo, so it can be imported as a base style:

<div class="demo-wrapper" id="demo0" code="" source="https://precog.mapzen.com/tangrams/tangram-play/master/embed/?go=👌&scene=https://tangrams.github.io/tangram-docs/tutorials/editing-basemaps/editing-basemaps2.yaml#16.50417/40.78070/-73.96085"></div>

To modify it, identify the parameter you want to change, and then re-declare its whole branch, back to the root level. This will tell Tangram exactly which node you want to overwrite.

In this case, we'll change the `color` of the `major_road` sublayer. We don't need to include any of the other parameters in that layer, unless we want to change them – they already exist in the imported style, and will still take effect. Simple enough!

<div class="demo-wrapper" id="demo0" code="" source="https://precog.mapzen.com/tangrams/tangram-play/master/embed/?go=👌&scene=https://tangrams.github.io/tangram-docs/tutorials/editing-basemaps/editing-basemaps3.yaml#16.50417/40.78070/-73.96085"></div>

# customizing a house style

The Mapzen house styles are significantly more complex. Take the case of Refill, which is deceptively simple-looking – though it is monochrome, this style includes dozens of places where road color is specified, depending on the classification of road, its datasource, even the zoom level at which it's drawn. This means you'll have to change color values in many places.

So let's try it. First, open up the Refill style, ideally in a separate text editor, so you can easily navigate around it. Then, search for the roads layer, which can be found by searching for `roads:`.

Copy the entire layer into an editor somewhere – it could be Tangram Play, or the text editor of your choice. Play shares a handy "select similar" feature with Sublime Text – control-D will find the next instance of the selected text and add to the selection – then you can edit in multiple places at once, which comes in handy for the next step.

Now, we want to delete any branch which doesn't end with a `lines: color:` – so we can ignore all of the `outline` declarations (unless you want to change those too).

As of this writing, the roads layer is almost 1400 lines long, but after editing, it should be closer to 200 – all `color` declarations. Then, paste it into your new scene file, and all of those color declarations will overwrite the ones in the import.

Here's an example:

<div class="demo-wrapper" id="demo0" code="" source="https://precog.mapzen.com/tangrams/tangram-play/master/embed/?go=👌&scene=https://tangrams.github.io/tangram-docs/tutorials/editing-basemaps/editing-basemaps5.yaml#16.50417/40.78070/-73.96085"></div>

Congratulations! If you have trouble, drop us a line [on GitHub](http://github.com/tangrams/tangram/issues), [on Twitter](http://twitter.com/tangramjs), or [via email](mailto:tangram@mapzen.com).