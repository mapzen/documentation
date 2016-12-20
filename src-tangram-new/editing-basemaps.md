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

Tangram draws map features using its [built-in _draw styles_](https://mapzen.com/documentation/tangram/Styles-Overview/): `polygons`, `lines`, `points`, `text`, and `raster`. Using the `styles` element, you can customize the behavior of these draw styles, either by using the many built-in customization features, or by making your own effects from scratch using [shaders](https://mapzen.com/documentation/tangram/shaders/).

This tutorial will explore three things you can make with custom styles: dashed lines, transparent polygons, and shader effects.

[images]

Note: in the examples in this tutorial, we are relying on the [layer name shortcut](https://mapzen.com/documentation/tangram/Filters-Overview/#layer-name-shortcut) and [style name shortcut](https://mapzen.com/documentation/tangram/Styles-Overview.md#using-styles).

## Dashed Lines

Let's use one of the built-in style customization options, [`dash`](https://mapzen.com/documentation/tangram/styles#dash), to draw some dashed lines. Add a datasource to your map with a [`source`](https://mapzen.com/documentation/tangram/source) entry, then add some lines to your map - let's start with road features.

Note: This tutorial uses Tangram's interactive scenefile editor, [Tangram Play](https://mapzen.com/tangram/play/) – type in the embedded editors to see real-time updates!

<div class="demo-wrapper" id="demo0" code="" source="https://precog.mapzen.com/tangrams/tangram-play/master/embed/?go=👌&scene=https://tangrams.github.io/tangram-docs/tutorials/editing-basemaps/editing-basemaps1.yaml#11.8002/41.3381/69.2698"></div>

But what do you do if you want to customize the house style itself? This is a bit trickier, and involves a bit of detective work.

First, you must know which features you wish to modify. The broader the class of features you want to change, the trickier it will be to change them. In our house styles, a given feature may be affected by multiple styles and sets of drawing rules, specifying a slightly different style at various zoom levels, and for various sub-classifications of the data. So, once you've picked a feature, you must understand how that feature is currently drawn.

## Basic Style Override

Before we start pulling apart a house style, let's start with a simpler example to see the basic method to override a style. Here's a very basic Tangram scene file:

<div class="demo-wrapper" id="demo1" code="" source="https://precog.mapzen.com/tangrams/tangram-play/master/embed/?go=👌&scene=https://tangrams.github.io/tangram-docs/tutorials/editing-basemaps/simple-basemap.yaml#11.8002/41.3381/69.2698"></div>

We've saved this scene file to the Tangram documentation repo, so it can be imported as a base style in a Tangram scene file, like so:

```yaml
import: https://tangrams.github.io/tangram-docs/tutorials/editing-basemaps/simple-basemap.yaml
```

Then, to modify it, identify the parameter you want to change, and then re-declare its whole branch, back to the root level. This will tell Tangram exactly which node you want to overwrite.

In this case, we'll change the `color` of the `major_road` sublayer. We don't need to include any of the other parameters in that layer, unless we want to change them – they already exist in the imported style, and will still take effect. Simple enough!

<div class="demo-wrapper" id="demo3" code="" source="https://precog.mapzen.com/tangrams/tangram-play/master/embed/?go=👌&scene=https://tangrams.github.io/tangram-docs/tutorials/editing-basemaps/editing-basemaps3.yaml#11.8002/41.3381/69.2698"></div>

## Customizing a House Style

The Mapzen house styles are significantly more complex. Take the case of [Refill](https://github.com/tangrams/refill-style), which is deceptively simple-looking – though it is monochrome, this style includes dozens of places where road color is specified, depending on the classification of road, its datasource, even the zoom level at which it's drawn. This means you'll have to change color values in many places.

So let's try it. First, open up the Refill style and take a look at it: https://github.com/tangrams/refill-style/blob/gh-pages/refill-style.yaml

Then, open it in a separate text editor, so you can easily navigate around. Then, search for the roads layer, which can be found by searching for `roads:` – it starts like this:

```yaml
roads:
        data: { source: mapzen, layer: roads }
        filter: { not: { kind: rail } }
        draw:
            lines:
            ...
```

Copy the entire "roads" layer into an editor somewhere – it could be Tangram Play, or the text editor of your choice. Tangram Play has a handy "select similar" feature – control-D will find the next instance of the selected text and add to the selection, allowing you to edit in multiple places at once, which comes in handy for the next step.

Now, we want to delete any branch which doesn't end with a `lines: color:` – so all of the `filter` declarations, and `width` declaration, even the `outline` declarations: all of those and their descendants can be deleted.

So this block:

```yaml
minor_road:
    filter: { kind: minor_road } ######################################## delete
    draw:
        lines:
            color: [[12, global.minor_road1], [17, global.minor_road2]]
            width: [[12, 1.0px], [14, 1.5px], [15, 3px], [16, 5m]] ###### delete
            outline: #################################################### delete
                width: [[12, 0px], [14, .5px], [17, 1px]] ############### delete
```

Would become this:

```yaml
minor_road:
    draw:
        lines:
            color: [[12, global.minor_road1], [17, global.minor_road2]]
```

Then, change all of the color values to something festive. Red is a classic choice:

```yaml
minor_road:
    draw:
        lines:
            color: red
```

As of this writing, the roads layer is almost 1400 lines long, but after editing, it should be closer to 200 – and all made up of `color` declarations. When you have that, paste it into your new scene file under the `import`, and all of those color declarations will overwrite the ones in the import.

Here's an example scene file: https://github.com/tangrams/tangram-docs/blob/gh-pages/tutorials/editing-basemaps/editing-basemaps4.yaml

And here's what it looks like:

<div class="demo-wrapper" id="demo4" code="" source="https://precog.mapzen.com/tangrams/tangram-play/master/embed/?go=👌&scene=https://tangrams.github.io/tangram-docs/tutorials/editing-basemaps/editing-basemaps4.yaml#11.8002/41.3381/69.2698"></div>

Congratulations! Those are the basics of customizing an imported scene file. In fact there's no advanced technique, that's it.

Questions? Comments? Drop us a line [on GitHub](http://github.com/tangrams/tangram/issues), [on Twitter](http://twitter.com/tangramjs), or [via email](mailto:tangram@mapzen.com).
