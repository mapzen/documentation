custom styling with styles

How to customize tangram's built-in draw styles to make custom map looks

Tangram draws mapping features using its draw styles.

There are a few built-in styles: polygons, lines, points, text, and raster. Using the `styles` element, you can use one of these built-in draw styles as a `base`, and customize its behavior, using some of the many built-in customization features, or by making your own from scratch using shaders.

## Dashed lines with built-in `dash` options

Let's use one of the built-in customization options, `dash`, to draw some dashed lines. Add a datasource to your map with a 'source', then add some lines to your map - let's start with roads features.

https://mapzen.com/tangram/play/?#16.50417/40.78070/-73.96085

sources:
    mapzen:
        type: TopoJSON
        url: https://tile.mapzen.com/mapzen/vector/v1/all/{z}/{x}/{y}.topojson

layers:
    roads:
        data: { source: mapzen }
        draw:
            lines:
                order: 1
                width: 5px
                color: gray

now let's make a custom draw style, let's call it '_dashes' – the underscore is a handy way to remember which things we named ourselves. The `dash` parameter takes an array, which sets the length of the dashes and gaps.

sources:
    mapzen:
        type: TopoJSON
        url: https://tile.mapzen.com/mapzen/vector/v1/all/{z}/{x}/{y}.topojson

styles:
    _dashes:
        base: lines
        dash: [1, 1]

layers:
    roads:
        data: { source: mapzen }
        draw:
            lines:
                order: 1
                width: 5px
                color: gray

Then, set the drawstyle in your roads layer to '_dashes', and it will be drawn in our custom style. The values of the `dash` parameter are a ratios to the width of the line – so a value of 1 will produce a square dash or gap, a value of `2` will make that dash or gap twice as long as the line's width, and `.5` will be half the width of the line. Try different values below:

sources:
    mapzen:
        type: TopoJSON
        url: https://tile.mapzen.com/mapzen/vector/v1/all/{z}/{x}/{y}.topojson

styles:
    _dashes:
        base: lines
        dash: [1, 1]

layers:
    roads:
        data: { source: mapzen }
        draw:
            _dashes:
                order: 1
                width: 5px
                color: gray

By default, the dash style has transparent background, but we can give it a color using the dash_background_color option:

sources:
    mapzen:
        type: TopoJSON
        url: https://tile.mapzen.com/mapzen/vector/v1/all/{z}/{x}/{y}.topojson

styles:
    _dashes:
        base: lines
        dash: [1, 1]
        dash_background_color: pink

layers:
    roads:
        data: { source: mapzen }
        draw:
            _dashes:
                order: 1
                width: 5px
                color: gray

We can also apply an outline:

sources:
    mapzen:
        type: TopoJSON
        url: https://tile.mapzen.com/mapzen/vector/v1/all/{z}/{x}/{y}.topojson

styles:
    _dashes:
        base: lines
        dash: [2, 1]
        dash_background_color: pink

layers:
    roads:
        data: { source: mapzen }
        draw:
            _dashes:
                order: 1
                width: 5px
                color: gray
                outline:
                    color: pink
                    width: 1px

## Transparency with built-in 'blend' modes

Now let's add transparency to a polygons layer, using another custom styling option, `blend`.

Start with a buildings data layer:
https://mapzen.com/tangram/play/?#18.07925/40.76442/-73.98058

sources:
    mapzen:
        type: TopoJSON
        url: https://tile.mapzen.com/mapzen/vector/v1/all/{z}/{x}/{y}.topojson

layers:
    buildings:
        data: { source: mapzen }
        draw:
            buildings:
                order: 1
                color: [.7, .7, .7]
                extrude: true

Then, add a new style based on the 'polygons' style – this one is named '_transparent'.

sources:
    mapzen:
        type: TopoJSON
        url: https://tile.mapzen.com/mapzen/vector/v1/all/{z}/{x}/{y}.topojson

styles:
    _transparent:
        base: polygons

layers:
    buildings:
        data: { source: mapzen }
        draw:
            polygons:
                order: 1
                color: [.7, .7, .7]
                extrude: true

Then, add a `blend` mode of `overlay`, and set our buildings draw style to match the name of our custom style:

sources:
    mapzen:
        type: TopoJSON
        url: https://tile.mapzen.com/mapzen/vector/v1/all/{z}/{x}/{y}.topojson

styles:
    _transparent:
        base: polygons
        blend: overlay

layers:
    buildings:
        data: { source: mapzen }
        draw:
            _transparent:
                order: 1
                color: [.75, .75, .75, .3]
                extrude: true

It doesn't look any different! The blend modes expect an alpha value, so let's add one to the building layer's `color` now:

sources:
    mapzen:
        type: TopoJSON
        url: https://tile.mapzen.com/mapzen/vector/v1/all/{z}/{x}/{y}.topojson

styles:
    _transparent:
        base: polygons
        blend: overlay

layers:
    buildings:
        data: { source: mapzen }
        draw:
            _transparent:
                order: 1
                color: [.75, .75, .75, .3]
                extrude: true

Experiment with different RGB and alpha values above!

## Shader effects with custom draw styles

Custom shaders are also achieved through custom `styles`, using the `shaders` block. Let's start with our buildings layer, with a new style named `_custom`:

sources:
    mapzen:
        type: TopoJSON
        url: https://tile.mapzen.com/mapzen/vector/v1/all/{z}/{x}/{y}.topojson

styles:
    _custom:
        base: polygons

layers:
    buildings:
        data: { source: mapzen }
        draw:
            _custom:
                order: 1
                color: [.75, .75, .75]
                extrude: true

Then, add a `shaders` block, with a `blocks` block and a `color` block inside that. This `color` block will hold the shader code, which is written in GLSL. To start off (and to tell it's working) we'll set the output color to magenta:

sources:
    mapzen:
        type: TopoJSON
        url: https://tile.mapzen.com/mapzen/vector/v1/all/{z}/{x}/{y}.topojson

styles:
    _custom:
        base: polygons
        shaders:
            blocks:
                color: |
                    color.rgb = vec3(1, 0, 1);

layers:
    buildings:
        data: { source: mapzen }
        draw:
            _custom:
                order: 1
                order: 1
                extrude: true

Now we can write functions to control the color of our buildings directly, using built-in variables if we wish to tie the color to properties of the geometry or scene. Let's get the `worldPosition()` of each vertex, and then color the buildings based on their height:

sources:
    mapzen:
        type: TopoJSON
        url: https://tile.mapzen.com/mapzen/vector/v1/all/{z}/{x}/{y}.topojson

styles:
    _custom:
        base: polygons
        shaders:
            blocks:
                color: |
                    color.rgb = vec3(worldPosition().z) / 100.;

layers:
    buildings:
        data: { source: mapzen }
        draw:
            _custom:
                order: 1
                order: 1
                extrude: true

In the shaders, the `vec3()` is necessary to convert worldPosition().z, which is a single `float`, into a `vec3()`, so it can be compatible with color.rgb, which is also a vec3() – you can tell because of the three channels: `.rgb`. But instead of doing this explicitly, there'a a cute trick you can do called "swizzling" which lets you mix and match channels to implicitly declare a vec3():

`color.rgb = worldPosition().zzz / 100.;`

If we add `animated: true` to the style, we can make effects based on the `u_time` internal variable:

sources:
    mapzen:
        type: TopoJSON
        url: https://tile.mapzen.com/mapzen/vector/v1/all/{z}/{x}/{y}.topojson

styles:
    _custom:
        base: polygons
        animated: true
        shaders:
            blocks:
                color: |
                    color.rgb = worldPosition().zzz / 100.;
                    color *= sin(u_time);

layers:
    buildings:
        data: { source: mapzen }
        draw:
            _custom:
                order: 1
                color: white
                extrude: true

Experiment with different `style` and `layer` `color` values to see the way the `shader`'s `color` affects the draw layer's color.

## A note about type casting

When writing Tangram shaders, you might get an error like this:

`'+' : wrong operand types no operation '+' exists that takes a left-hand operand of type 'highp float' and a right operand of type 'const int' (or there is no acceptable conversion)`

In general this means one of the numbers in your expression is missing a decimal point, like `.5 + 1' – this makes GLSL sad.

Some languages (like JavaScript) do automatic type conversion, but the version of GLSL used in Tangram doesn't – you have to tell it to do everything explicitly, which makes it a bit tedious, but for this reason it's harder for GLSL to misinterpret your intentions.

So when writing GLSL you have to make sure that each expression uses a constant data type throughout. For instance, the decimal place at the end of `100.` makes it a floating point value, so that it's compatible with the other floating point values in the expression – the `.rgb` and `worldPosition()` values. It's best to get in the habit of adding a decimal to every number in GLSL, unless you know for sure you don't need it.