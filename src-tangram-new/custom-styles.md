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

<div class="demo-wrapper" id="demo0" code="" source="https://precog.mapzen.com/tangrams/tangram-play/master/embed/?go=👌&scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom1.yaml#16.50417/40.78070/-73.96085"></div>

Now let's make a custom _draw style_ called "_dashes" (it could be anything, and the underscore isn't required, but it's a handy way to remember which things we named ourselves). The `dash` parameter takes an array, which sets the length of the dashes and gaps.

<div class="demo-wrapper" id="demo1" code="" source="https://precog.mapzen.com/tangrams/tangram-play/master/embed/?go=👌&scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom2.yaml#16.50417/40.78070/-73.96085"></div>

Then, rename the _draw group_ of the "roads" layer from `lines` to `_dashes`, and the roads will be drawn in the custom style.

The values of the `dash` parameter are relative to the `width` of the line – a value of `2` produces a dash or gap twice as long as the line's width, `.5` is half the line's width, and `1` produces a square.

Try different values for `dash` and `width` below:

<div class="demo-wrapper" id="demo3" code="" source="https://precog.mapzen.com/tangrams/tangram-play/master/embed/?go=👌&scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom3.yaml#16.50417/40.78070/-73.96085"></div>

By default, the `dash` style has a transparent background, but you can give the background a solid color using the `dash_background_color` option:

<div class="demo-wrapper" id="demo4" code="" source="https://precog.mapzen.com/tangrams/tangram-play/master/embed/?go=👌&scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom4.yaml#16.50417/40.78070/-73.96085"></div>

You can also apply an `outline`:

<div class="demo-wrapper" id="demo5" code="" source="https://precog.mapzen.com/tangrams/tangram-play/master/embed/?go=👌&scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom5.yaml#16.50417/40.78070/-73.96085"></div>

## Transparency with Blend Modes

Now let's add transparency to a polygons layer, using another custom styling option, [`blend`](https://mapzen.com/documentation/tangram/styles/#blend).

Start with a buildings data layer drawn with a basic `polygons` style:

<div class="demo-wrapper" id="demo6" code="" source="https://precog.mapzen.com/tangrams/tangram-play/master/embed/?go=👌&scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom6.yaml#17/40.76442/-73.98058"></div>

Then, add a new style based on the `polygons` style – this one is named "_transparent".

<div class="demo-wrapper" id="demo7" code="" source="https://precog.mapzen.com/tangrams/tangram-play/master/embed/?go=👌&scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom7.yaml#17/40.76442/-73.98058"></div>

Add a `blend` mode of `overlay`, and set the buildings draw style to match the name of the custom style:

<div class="demo-wrapper" id="demo8" code="" source="https://precog.mapzen.com/tangrams/tangram-play/master/embed/?go=👌&scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom8.yaml#17/40.76442/-73.98058"></div>

It doesn't look transparent! That's because the building layer's color value is a solid gray: `[.7, .7, .7]`. The three values in that array are the Red, Green, and Blue channels – but there's another possible channel for Alpha, and if you don't specify it, it defaults to `1`, which is opaque. The `blend` modes respect alpha, so let's add an alpha value of `.5` to that color array, which will give it 50% opacity:

<div class="demo-wrapper" id="demo9" code="" source="https://precog.mapzen.com/tangrams/tangram-play/master/embed/?go=👌&scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom9.yaml#17/40.76442/-73.98058"></div>

Experiment with different RGB and alpha values above!

## Shader Effects

Custom shaders are also achieved through custom `styles`, using the [`shaders`](https://mapzen.com/documentation/tangram/shaders/#shaders) block. Starting with the buildings layer again, add a new entry to the `styles` block named "_custom":

<div class="demo-wrapper" id="demo10" code="" source="https://precog.mapzen.com/tangrams/tangram-play/master/embed/?go=👌&scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom10.yaml#17/40.76442/-73.98058"></div>

Then, add a `shaders` block to the style, with a `blocks` block and a `color` block inside that. This `color` block will hold the shader code, which is written in GLSL. To start off (and to tell it's working) set the output color to something like `vec3(1, 0, 1)` (this is GLSL's way of specifying the RGB values for magenta):

<div class="demo-wrapper" id="demo11" code="" source="https://precog.mapzen.com/tangrams/tangram-play/master/embed/?go=👌&scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom11.yaml#17/40.76442/-73.98058"></div>

Now you can write shader functions to control the color of the buildings directly. You can also use built-in variables if you wish to control the color with properties of the geometry or scene. Let's get the `worldPosition()` of each vertex and reference that in the shader's `color` block, so we can color the buildings based on their z-value (aka height):

<div class="demo-wrapper" id="demo12" code="" source="https://precog.mapzen.com/tangrams/tangram-play/master/embed/?go=👌&scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom12.yaml#17/40.76442/-73.98058"></div>

And when `animated: true` is added to the style, you can make effects based on the `u_time` internal variable:

<div class="demo-wrapper" id="demo13" code="" source="https://precog.mapzen.com/tangrams/tangram-play/master/embed/?go=👌&scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom13.yaml#17/40.76442/-73.98058"></div>

Experiment with different `color` values to see the way the shader's `color` and the draw layer's `color` interact.

For more about internal variables available in shaders, see [Built-ins, defaults, and presets](shaders.md#built-ins-defaults-and-presets).

Questions? Comments? Drop us a line [on GitHub](http://github.com/tangrams/tangram/issues), [on Twitter](http://twitter.com/tangramjs), or [via email](mailto:tangram@mapzen.com).
