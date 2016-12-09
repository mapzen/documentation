Tangram draws map features using its built-in styles: `polygons`, `lines`, `points`, `text`, and `raster`. Using the `styles` element, you can customize the behavior of these draw styles, either by using the many built-in customization features, or by making your own effects from scratch using [shaders](shaders.md).

## Dashed lines with built-in `dash` options

Let's use one of the built-in style customization options, [`dash`](styles.md#dash), to draw some dashed lines. Add a datasource to your map with a [`source`]*source.md) entry, then add some lines to your map - let's start with road features.

<iframe class="demo-wrapper" src="https://mapzen.com/tangram/play/embed/?scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom1.yaml#16.50417/40.78070/-73.96085"></iframe>

Now let's make a custom _draw style_, let's call it '_dashes' – the underscore is a handy way to remember which things we named ourselves. The `dash` parameter takes an array, which sets the length of the dashes and gaps.

<iframe class="demo-wrapper" src="https://mapzen.com/tangram/play/embed/?scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom2.yaml#16.50417/40.78070/-73.96085"></iframe>

Then, set the `style` of the roads layer from `polygons` to `_dashes`, and it will be drawn in our custom style. The values of the `dash` parameter are relative to the `width` of the line – a value of `2` produces a dash or gap twice as long as the line's width, `.5` is half the line's width, and `1` produces a square. Try different values for `dash` and `width` below:

<iframe class="demo-wrapper" src="https://mapzen.com/tangram/play/embed/?scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom3.yaml#16.50417/40.78070/-73.96085"></iframe>

By default, the `dash` style has a transparent background, but we can give the background a solid color using the `dash_background_color` option:

<iframe class="demo-wrapper" src="https://mapzen.com/tangram/play/embed/?scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom4.yaml#16.50417/40.78070/-73.96085"></iframe>

We can also apply an `outline`:

<iframe class="demo-wrapper" src="https://mapzen.com/tangram/play/embed/?scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom5.yaml#16.50417/40.78070/-73.96085"></iframe>

## Transparency with blend modes

Now let's add transparency to a polygons layer, using another custom styling option, `blend`.

Start with a buildings data layer:

<iframe class="demo-wrapper" src="https://mapzen.com/tangram/play/embed/?scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom6.yaml#18.07925/40.76442/-73.98058"></iframe>

Then, add a new style based on the 'polygons' style – this one is named '_transparent'.

<iframe class="demo-wrapper" src="https://mapzen.com/tangram/play/embed/?scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom7.yaml#18.07925/40.76442/-73.98058"></iframe>

Then, add a `blend` mode of `overlay`, and set our buildings draw style to match the name of our custom style:

<iframe class="demo-wrapper" src="https://mapzen.com/tangram/play/embed/?scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom8.yaml#18.07925/40.76442/-73.98058"></iframe>

It doesn't look any different! The blend modes expect an alpha value, so let's add one to the building layer's `color` now:

<iframe class="demo-wrapper" src="https://mapzen.com/tangram/play/embed/?scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom9.yaml#18.07925/40.76442/-73.98058"></iframe>

Experiment with different RGB and alpha values above!

## Shader effects with custom draw styles

Custom shaders are also achieved through custom `styles`, using the `shaders` block. Let's start with our buildings layer, with a new style named `_custom`:

<iframe class="demo-wrapper" src="https://mapzen.com/tangram/play/embed/?scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom10.yaml#18.07925/40.76442/-73.98058"></iframe>

Then, add a `shaders` block, with a `blocks` block and a `color` block inside that. This `color` block will hold the shader code, which is written in GLSL. To start off (and to tell it's working) we'll set the output color to magenta:

<iframe class="demo-wrapper" src="https://mapzen.com/tangram/play/embed/?scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom11.yaml#18.07925/40.76442/-73.98058"></iframe>

Now we can write functions to control the color of our buildings directly, using built-in variables if we wish to control the color with properties of the geometry or scene. Let's get the `worldPosition()` of each vertex, and then color the buildings based on their height:

<iframe class="demo-wrapper" src="https://mapzen.com/tangram/play/embed/?scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom12.yaml#18.07925/40.76442/-73.98058"></iframe>

If we add `animated: true` to the style, we can make effects based on the `u_time` internal variable:

<iframe class="demo-wrapper" src="https://mapzen.com/tangram/play/embed/?scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom13.yaml#18.07925/40.76442/-73.98058"></iframe>

Experiment with different `style` and `layer` `color` values to see the way the `shader`'s `color` affects the draw layer's color.

For more about internal variables available in shaders, see [Built-ins, defaults, and presets](shaders.md#built-ins-defaults-and-presets).

## A note about type casting

When writing Tangram shaders, you might get an error like this:

<span style="background-color: yellow">`'+' : wrong operand types no operation '+' exists that takes a left-hand operand of type 'highp float' and a right operand of type 'const int' (or there is no acceptable conversion)`</span>

In general this means one of the numbers in your expression is missing a decimal point, like `.5 + 1' – this makes GLSL sad.

Some languages (like JavaScript) do automatic type conversion, but the version of GLSL used in Tangram doesn't – you have to tell it to do everything explicitly, which makes it a bit tedious, but for this reason it's harder for GLSL to misinterpret your intentions.

So when writing GLSL you have to make sure that each expression uses a constant data type throughout. For instance, the decimal place at the end of `100.` makes it a floating point value, so that it's compatible with the other floating point values in the expression – the `.rgb` and `worldPosition()` values. It's best to get in the habit of adding a decimal to every number in GLSL, unless you know for sure you don't need it.