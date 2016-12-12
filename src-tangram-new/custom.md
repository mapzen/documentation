<script>
document.domain = "mapzen.com"
window.BlobBuilder = window.BlobBuilder || window.WebKitBlobBuilder || window.MozBlobBuilder || window.MSBlobBuilder;

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
        if (typeof iframe.contentWindow.scene != 'undefined') {
            console.log(JSON.stringify(iframe.contentWindow.scene.config));
            el.removeChild(iframe);
        }
    }
}
function show(el) {
    if (typeof el != 'undefined') {
        iframe = el.getElementsByTagName("iframe")[0];
        if (typeof iframe == "undefined") {
            iframe = document.createElement("iframe");
            el.appendChild(iframe);
            iframe.style.height = "100%";
            if (el.getAttribute("code") !='') {
                var bb = new BlobBuilder();
                bb.append(el.getAttribute("code"));
                var blob = bb.getBlob('text/yaml');
                // iframe.src = el.getAttribute("source");
                iframe.src = window.URL.createObjectURL(blob);
            } else {
                iframe.src = el.getAttribute("source");
            }
        }
    }
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
                if (j != i && j != i+1 && j != i+2) {
                    hide(elements[j]);
                }
            }
            break;
        }
    }
}, 500);
</script>
<style>
#demo-wrapper {
    margin-bottom: 1em;
}
</style>

Tangram draws map features using its built-in styles: `polygons`, `lines`, `points`, `text`, and `raster`. Using the `styles` element, you can customize the behavior of these draw styles, either by using the many built-in customization features, or by making your own effects from scratch using [shaders](shaders.md).

## Dashed lines with built-in `dash` options

Let's use one of the built-in style customization options, [`dash`](styles.md#dash), to draw some dashed lines. Add a datasource to your map with a [`source`](source.md) entry, then add some lines to your map - let's start with road features.

<!-- <div class="demo-wrapper" source="https://precog.mapzen.com/tangrams/tangram-play/master/embed/?scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom1.yaml#16.50417/40.78070/-73.96085"></div>
 -->
<div class="demo-wrapper" code="" source="https://mapzen.com/tangram/play/embed/?scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom1.yaml#16.50417/40.78070/-73.96085"></div>

Note: in the examples in this tutorial, we are relying on a couple of similar shortcuts to set our _data layers_ and _draw styles_. Rather than give a custom name to each layer and set its data layer separately, like so:

```yaml
layers:
    _my_roads:
        data: { source: mapzen, layer: roads }
```

We're omitting the `layer` declaration, and simply naming our layer the name of the data layer we wish to draw:

```
layers:
    roads:
        data: { source: mapzen }
```

Similarly, rather than giving a custom name to each _draw group_ and specify its _draw style_ explicitly, like so:

```yaml
layers:
    roads:
        data: { source: mapzen }
        draw:
            _my_lines:
                style: lines
                width: 2px
```

We're omitting the `style` declaration, and simply naming our _draw group_ the name of the _draw style_ we wish to use:

```
layers:
    roads:
        data: { source: mapzen }
        draw:
            lines:
                width: 2px
```

Now let's make a custom _draw style_, let's call it '_dashes' – the underscore is a handy way to remember which things we named ourselves. The `dash` parameter takes an array, which sets the length of the dashes and gaps.

<div class="demo-wrapper" code="" source="https://mapzen.com/tangram/play/embed/?scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom2.yaml#16.50417/40.78070/-73.96085"></div>

Then, rename the _draw group_ of the "roads" layer from `polygons` to `_dashes`, and they will be drawn in our custom style.

The values of the `dash` parameter are relative to the `width` of the line – a value of `2` produces a dash or gap twice as long as the line's width, `.5` is half the line's width, and `1` produces a square.

Try different values for `dash` and `width` below:

<div class="demo-wrapper" code="" source="https://mapzen.com/tangram/play/embed/?scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom3.yaml#16.50417/40.78070/-73.96085"></div>

By default, the `dash` style has a transparent background, but we can give the background a solid color using the `dash_background_color` option:

<div class="demo-wrapper" code="" source="https://mapzen.com/tangram/play/embed/?scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom4.yaml#16.50417/40.78070/-73.96085"></div>

We can also apply an `outline`:

<div class="demo-wrapper" code="" source="https://mapzen.com/tangram/play/embed/?scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom5.yaml#16.50417/40.78070/-73.96085"></div>

## Transparency with blend modes

Now let's add transparency to a polygons layer, using another custom styling option, `blend`.

Start with a buildings data layer:

<div class="demo-wrapper" code="" source="https://mapzen.com/tangram/play/embed/?scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom6.yaml#18.07925/40.76442/-73.98058"></div>

Then, add a new style based on the 'polygons' style – this one is named '_transparent'.

<div class="demo-wrapper" code="" source="https://mapzen.com/tangram/play/embed/?scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom7.yaml#18.07925/40.76442/-73.98058"></div>

Add a `blend` mode of `overlay`, and set our buildings draw style to match the name of our custom style:

<div class="demo-wrapper" code="" source="https://mapzen.com/tangram/play/embed/?scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom8.yaml#18.07925/40.76442/-73.98058"></div>

It doesn't look transparent! That's because the building layer's color value is a solid gray (`[.7, .7, .7]`). Those three values are the Red, Green, and Blue channels – but there's another possible value, for Alpha, and if you don't specify it, it defaults to `1`, which is opaque. The blend modes work with alpha, so let's change that color value to `[.7, .7, .7, .5]`, half-transparent:

<div class="demo-wrapper" code="" source="https://mapzen.com/tangram/play/embed/?scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom9.yaml#18.07925/40.76442/-73.98058"></div>

Experiment with different RGB and alpha values above!

## Shader effects with custom draw styles

Custom shaders are also achieved through custom `styles`, using the `shaders` block. Let's start with our buildings layer, with a new style named `_custom`:

<div class="demo-wrapper" code="" source="https://mapzen.com/tangram/play/embed/?scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom10.yaml#18.07925/40.76442/-73.98058"></div>

Then, add a `shaders` block, with a `blocks` block and a `color` block inside that. This `color` block will hold the shader code, which is written in GLSL. To start off (and to tell it's working) we'll set the output color to magenta:

<div class="demo-wrapper" code="" source="https://mapzen.com/tangram/play/embed/?scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom11.yaml#18.07925/40.76442/-73.98058"></div>

Now we can write functions to control the color of our buildings directly, using built-in variables if we wish to control the color with properties of the geometry or scene. Let's get the `worldPosition()` of each vertex, and then color the buildings based on their height:

<div class="demo-wrapper" code="" source="https://mapzen.com/tangram/play/embed/?scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom12.yaml#18.07925/40.76442/-73.98058"></div>

If we add `animated: true` to the style, we can make effects based on the `u_time` internal variable:

<div class="demo-wrapper" code="" source="https://mapzen.com/tangram/play/embed/?scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom13.yaml#18.07925/40.76442/-73.98058"></div>

Experiment with different `style` and `layer` `color` values to see the way the `shader`'s `color` affects the draw layer's color.

For more about internal variables available in shaders, see [Built-ins, defaults, and presets](shaders.md#built-ins-defaults-and-presets).

## A note about type casting

When writing Tangram shaders, you might get an error like this:

<code style="color:black;background-color: #ffcc00">'+' : wrong operand types no operation '+' exists that takes a left-hand operand of type 'highp float' and a right operand of type 'const int' (or there is no acceptable conversion)</code>

In general this means one of the numbers in your expression is missing a decimal point, like `.5 + 1` – this makes GLSL sad.

Some languages (like JavaScript) do automatic type conversion, but the version of GLSL used in Tangram doesn't – you have to tell it to do everything explicitly, which makes it a bit tedious, but for this reason it's harder for GLSL to misinterpret your intentions.

So when writing GLSL you have to make sure that each expression uses a constant data type throughout. For instance, the decimal place at the end of `100.` makes it a floating point value, so that it's compatible with the other floating point values in the expression – the `.rgb` and `worldPosition()` values. It's best to get in the habit of adding a decimal to every number in GLSL, unless you know for sure you don't need it.