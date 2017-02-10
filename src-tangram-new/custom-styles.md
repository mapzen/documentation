<link rel='stylesheet' href='https://tangrams.github.io/tangram-docs/css/tutorial-embeds.css'>

Tangram draws map features using its [built-in _draw styles_](https://mapzen.com/documentation/tangram/Styles-Overview/): `polygons`, `lines`, `points`, `text`, and `raster`. Using the `styles` element, you can customize the behavior of these draw styles, either by using the many built-in customization features, or by making your own effects from scratch using [shaders](https://mapzen.com/documentation/tangram/shaders/).

This tutorial will explore three things you can make with custom styles: dashed lines, transparent polygons, and shader effects.

[images]

Note: in the examples in this tutorial, we are relying on the [layer name shortcut](https://mapzen.com/documentation/tangram/Filters-Overview/#layer-name-shortcut) and [style name shortcut](https://mapzen.com/documentation/tangram/Styles-Overview.md#using-styles).

## Dashed Lines

Let's use one of the built-in style customization options, [`dash`](https://mapzen.com/documentation/tangram/styles#dash), to draw some dashed lines. Add a datasource to your map with a [`source`](https://mapzen.com/documentation/tangram/source) entry, then add some lines to your map - let's start with road features.

Note: This tutorial uses Tangram's interactive scenefile editor, [Tangram Play](https://mapzen.com/tangram/play/) – type in the embedded editors to see real-time updates!

<div class="demo-wrap">
    <div class="demo" id="demo0" code="" source="https://precog.mapzen.com/tangrams/tangram-play/master/embed/?go=👌&scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom1.yaml#16.50417/40.78070/-73.96085"></div>
    <span class="caption"><a target="_blank" href="http://mapzen.com/tangram/play/?scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom1.yaml#16.50417/40.7807/-73.96085">( Open in Play ▶ )</a></span>
</div>

Now let's make a custom _draw style_ called "_dashes" – this name could be anything, and the leading underscore isn't required, but it's a handy way to remember which things we named ourselves. The `dash` parameter takes an array, which sets the length of the dashes and gaps.

<div class="demo-wrap">
    <div class="demo" id="demo1" code="" source="https://precog.mapzen.com/tangrams/tangram-play/master/embed/?go=👌&scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom2.yaml#16.50417/40.78070/-73.96085"></div>
    <span class="caption"><a target="_blank" href="http://mapzen.com/tangram/play/?scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom2.yaml#16.50417/40.7807/-73.96085">( Open in Play ▶ )</a></span>
</div>

Then, rename the _draw group_ of the "roads" layer from `lines` to `_dashes`, and the roads will be drawn in the custom style.

The values of the `dash` parameter are relative to the `width` of the line – a value of `2` produces a dash or gap twice as long as the line's width, `.5` is half the line's width, and `1` produces a square.

Try different values for `dash` and `width` below:

<div class="demo-wrap">
    <div class="demo" id="demo3" code="" source="https://precog.mapzen.com/tangrams/tangram-play/master/embed/?go=👌&scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom3.yaml#16.50417/40.78070/-73.96085"></div>
    <span class="caption"><a target="_blank" href="http://mapzen.com/tangram/play/?scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom3.yaml#16.50417/40.7807/-73.96085">( Open in Play ▶ )</a></span>
</div>

By default, the `dash` style has a transparent background, but you can give the background a solid color using the `dash_background_color` option:

<div class="demo-wrap">
    <div class="demo" id="demo4" code="" source="https://precog.mapzen.com/tangrams/tangram-play/master/embed/?go=👌&scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom4.yaml#16.50417/40.78070/-73.96085"></div>
    <span class="caption"><a target="_blank" href="http://mapzen.com/tangram/play/?scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom4.yaml#16.50417/40.7807/-73.96085">( Open in Play ▶ )</a></span>
</div>

You can also apply an `outline`:

<div class="demo-wrap">
    <div class="demo" id="demo5" code="" source="https://precog.mapzen.com/tangrams/tangram-play/master/embed/?go=👌&scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom5.yaml#16.50417/40.78070/-73.96085"></div>
    <span class="caption"><a target="_blank" href="http://mapzen.com/tangram/play/?scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom5.yaml#16.50417/40.7807/-73.96085">( Open in Play ▶ )</a></span>
</div>

## Transparency with Blend Modes

Now let's add transparency to a polygons layer, using another custom styling option, [`blend`](https://mapzen.com/documentation/tangram/styles/#blend).

Start with a buildings data layer drawn with a basic `polygons` style:

<div class="demo-wrap">
    <div class="demo" id="demo6" code="" source="https://precog.mapzen.com/tangrams/tangram-play/master/embed/?go=👌&scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom6.yaml#17/40.76442/-73.98058"></div>
    <span class="caption"><a target="_blank" href="http://mapzen.com/tangram/play/?scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom6.yaml#16.50417/40.7807/-73.96085">( Open in Play ▶ )</a></span>
</div>

Then, add a new style based on the `polygons` style – this one is named "_transparent".

<div class="demo-wrap">
    <div class="demo" id="demo7" code="" source="https://precog.mapzen.com/tangrams/tangram-play/master/embed/?go=👌&scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom7.yaml#17/40.76442/-73.98058"></div>
    <span class="caption"><a target="_blank" href="http://mapzen.com/tangram/play/?scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom7.yaml#16.50417/40.7807/-73.96085">( Open in Play ▶ )</a></span>
</div>

Add a `blend` mode of `overlay`, and set the buildings draw style to match the name of the custom style:

<div class="demo-wrap">
    <div class="demo" id="demo8" code="" source="https://precog.mapzen.com/tangrams/tangram-play/master/embed/?go=👌&scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom8.yaml#17/40.76442/-73.98058"></div>
    <span class="caption"><a target="_blank" href="http://mapzen.com/tangram/play/?scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom8.yaml#16.50417/40.7807/-73.96085">( Open in Play ▶ )</a></span>
</div>

It doesn't look transparent! That's because the building layer's color value is a solid gray: `[.7, .7, .7]`. The three values in that array are the Red, Green, and Blue channels – but there's another possible channel for Alpha, and if you don't specify it, it defaults to `1`, which is opaque. The `blend` modes respect alpha, so let's add an alpha value of `.5` to that color array, which will give it 50% opacity:

<div class="demo-wrap">
    <div class="demo" id="demo9" code="" source="https://precog.mapzen.com/tangrams/tangram-play/master/embed/?go=👌&scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom9.yaml#17/40.76442/-73.98058"></div>
    <span class="caption"><a target="_blank" href="http://mapzen.com/tangram/play/?scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom9.yaml#16.50417/40.7807/-73.96085">( Open in Play ▶ )</a></span>
</div>

Experiment with different RGB and alpha values above!

## Shader Effects

Custom shaders are also achieved through custom `styles`, using the [`shaders`](https://mapzen.com/documentation/tangram/shaders/#shaders) block. Starting with the buildings layer again, add a new entry to the `styles` block named "_custom":

<div class="demo-wrap">
    <div class="demo" id="demo10" code="" source="https://precog.mapzen.com/tangrams/tangram-play/master/embed/?go=👌&scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom10.yaml#17/40.76442/-73.98058"></div>
    <span class="caption"><a target="_blank" href="http://mapzen.com/tangram/play/?scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom10.yaml#16.50417/40.7807/-73.96085">( Open in Play ▶ )</a></span>
</div>

Then, add a `shaders` block to the style, with a `blocks` block and a `color` block inside that. This `color` block will hold the shader code, which is written in GLSL. To start off (and to tell it's working) set the output color to something like `vec3(1, 0, 1)` (this is GLSL's way of specifying the RGB values for magenta):

<div class="demo-wrap">
    <div class="demo" id="demo11" code="" source="https://precog.mapzen.com/tangrams/tangram-play/master/embed/?go=👌&scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom11.yaml#17/40.76442/-73.98058"></div>
    <span class="caption"><a target="_blank" href="http://mapzen.com/tangram/play/?scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom11.yaml#16.50417/40.7807/-73.96085">( Open in Play ▶ )</a></span>
</div>

Now you can write shader functions to control the color of the buildings directly. You can also use built-in variables if you wish to control the color with properties of the geometry or scene. Let's get the `worldPosition()` of each vertex and reference that in the shader's `color` block, so we can color the buildings based on their z-value (aka height):

<div class="demo-wrap">
    <div class="demo" id="demo12" code="" source="https://precog.mapzen.com/tangrams/tangram-play/master/embed/?go=👌&scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom12.yaml#17/40.76442/-73.98058"></div>
    <span class="caption"><a target="_blank" href="http://mapzen.com/tangram/play/?scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom12.yaml#16.50417/40.7807/-73.96085">( Open in Play ▶ )</a></span>
</div>

And when `animated: true` is added to the style, you can make effects based on the `u_time` internal variable:

<div class="demo-wrap">
    <div class="demo" id="demo13" code="" source="https://precog.mapzen.com/tangrams/tangram-play/master/embed/?go=👌&scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom13.yaml#17/40.76442/-73.98058"></div>
    <span class="caption"><a target="_blank" href="http://mapzen.com/tangram/play/?scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom13.yaml#16.50417/40.7807/-73.96085">( Open in Play ▶ )</a></span>
</div>

Experiment with different `color` values to see the way the shader's `color` and the draw layer's `color` interact.

For more about internal variables available in shaders, see [Built-ins, defaults, and presets](https://mapzen.com/documentation/tangram/shaders/#built-ins-defaults-and-presets).

Questions? Comments? Drop us a line [on GitHub](http://github.com/tangrams/tangram/issues), [on Twitter](http://twitter.com/tangramjs), or [via email](mailto:tangram@mapzen.com).

<script src='https://tangrams.github.io/tangram-docs/src/tutorial-embeds.js'></script>