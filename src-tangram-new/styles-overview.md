Styles go here

# draw

*This is the technical documentation for Tangram's styling system. For a conceptual overview of the styling system, see the [Styles Overview](Styles-Overview.md).*

####`draw`
`draw` is an optional element in a [layer](layers.md) or [sublayer](layers.md#sublayer-name). It provides one or more *draw groups* for rendering the features that match the _layer_ or _sublayer_ directly above it. These _draw groups_ are the sub-elements of the `draw` element, as in this example:
```yaml
...
layers:
    water:
        data: { source: osm }
        draw:
            draw_group:
                ...
            another_draw_group:
                ...
```
A `draw` element can specify multiple groups, indicating that matching features should be drawn multiple times. In the example above, features that match the "water" layer will be drawn twice, once according to the style of `draw_group` and once with that of `another_draw_group`.

####draw group
The name of a _draw group_ can be any string. The sub-elements of a _draw group_ are parameters that determine various properties of how a feature will be drawn. These _style parameters_ are described in detail below.

A _draw group_ must specify the _style_ that will be used to draw a feature. It can do this in two ways:

 1. A _draw group_ may contain a parameter called `style` whose value names a _style_ (either a built-in _style_ or one defined in the `styles` element of the scene file). For example:

 ```yaml
 ...
 draw:
     fancy_road_lines:
         style: lines
         ... # more parameters follow
 ```
 2. If a _draw group_ does not contain a `style` parameter, the group's name is interpreted as the name of a _style_ (again, either a built-in _style_ or one from the `styles` element).

 ```yaml
 ...
 draw:
     lines:
         ... # no 'style' parameter follows
 ```

The 2nd, shorthand syntax is the preferred way to specify a _style_, however an explicit `style` parameter is necessary sometimes. For example, to draw a feature using the _lines_ style twice, the `draw` element would need two _draw groups_ with different names, e.g.
```yaml
...
draw:
    first_line:
        style: lines
        ... # more parameters follow
    second_line:
        style: lines
        ... # more parameters follow
```
Note that two _draw groups_ both named "lines" would be invalid YAML:

```yaml
...
draw:
    lines:
        ... # more parameters
    lines: # <- You can't do this in YAML!
        ... # more parameters
```


If the _style_ specified by a _draw group_ is neither a built-in _style_ nor a _style_ defined in the `styles` element, the group will draw nothing.

## style parameters

Many style parameters, such as [`color`](#color), are shared among draw styles – others are unique to particular draw styles.

####`align`
Optional _string_ or _array of strings_, one of `left`, `center`, `right`. Default is `center`, unless `anchor` is set (see below).

Sets alignment of text for multi-line labels — see [`text_wrap`](draw.md#text_wrap).

```yaml
text:
    align: left
```

####`anchor`
Optional _string_, one of `center`, `left`, `right`, `top`, `bottom`, `top-left`, `top-right`, `bottom-left`, or `bottom-right`. Default is `['bottom', 'top', 'right', 'left']`.

Applies to the `text` and `points` styles. Places the label or point/sprite on the specified side or corner of the feature. When an _array_ us used, each anchor position is tried in the order listed until a placement which does not collide is found.

```yaml
draw:
   points:
      ...
      text:
         anchor: [bottom, right, left, top]
```

If `offset` is also set, it is applied *in addition to* the anchor.

```yaml
text:
    anchor: bottom   # places the text so that the top of the text is directly below the feature
    offset: [0, 2px] # moves the text an additional 2px down
```

If `anchor` is set but `align` is not, then `align` will be set to an appropriate default value:

|If `anchor` is...|`align` defaults to...|
|-----------------|----------------------|
|`center`<br>`top`<br>`bottom`|`center`|
|`left`<br>`top-left`<br>`bottom-left`|`right`|
|`right`<br>`top-right`<br>`bottom-right`|`left`|

```yaml
text:
    anchor: bottom-left # the label will use `align: right` by default
```

####`buffer`
[JS-only] Optional _integer_ or _[integer, integer]_, in _px_. No default.

Applies to `points` and `text`. Specifies an optional buffer area that expands the collision bounding box of the feature, to avoid features from being rendered closer together than desired. A single value will be applied to all sides of the feature; a two-element array specifies separate horizontal and vertical buffering values.

```yaml
draw:
    points:
        buffer: [2px, 1px]: creates a two-pixel buffer on the left and right sides of the feature, and a one-pixel buffer on its top and bottom.
```

Buffers may be applied to both a _point_ and its attached _text_:

```yaml
draw:
    points:
        buffer: 1px # point portion has a one-pixel buffer
        ...
        text:
            buffer: 2px # text portion has a two-pixel buffer
            ...
```

####`cap`
Optional _string_, one of `butt`, `square`, or `round` following the [SVG protocol](http://www.w3.org/TR/SVG/painting.html#StrokeLinecapProperty). Default is `butt`.

Applies to the `lines` style. Sets the shape of the ends of features.

```yaml
draw:
    lines:
        color: black
        cap: round
```

####`centroid`
Optional _boolean_, default is `false`.

Applies to the `points` style. If true, draws points only at the centroid of a polygon.

```yaml
draw:
    points:
        centroid: true
```

####`collide`
Optional _boolean_. Defaults to `true`.

Applies to `points` and `text`.

A point or text draw group marked with `collide: false` will not be checked for any collisions.

```yaml
poi-icons:
    draw:
        points:
           collide: false
```

####`color`

Required* RGB _[number, number, number]_, RGBA _[number, number, number, number]_, _CSS color_, or _stops_. Can also be a _function_ which returns a color. RGB/RGBA value range is 0-1. No default.

Applies to `points`, `polygons`, and `lines`. (For `text`, see [fill](draw.md#fill).) Specifies the vertex color of the feature. This color will be passed to any active shaders and used in any light calculations as "color".

_CSS colors_ include the following color formats, as specified in the [W3C's Cascading Style Sheets specification](http://www.w3schools.com/cssref/css_colors_legal.asp):

- _named colors_: `red`, `blue`, `salmon`, `rebeccapurple`
- _hex colors_: `"#fff"`, `"#000"`, `"#9CE6E5"`
- _RGB colors_: `rgb(255, 190, 0)`
- _RGBA colors_**: `rgb(255, 190, 0, .5)`
- _HSL colors_: `hsl(180, 100%, 100%)`
- _HSL colors_**: `hsla(180, 100%, 100%, 50%)`

`color` is not required if a style is used which specifies a shader with a _color block_ or a _filter block_. See [shaders: blocks](shaders.md#blocks).

Currently, alpha values are ignored in the `add` and `multiply` `blend` modes, and respected in the `inlay` and `overlay` modes. For more on this, see the [`blend`](styles.md#blend) entry.


```yaml
draw:
    polygons:
        color: [.7, .7, .7]
```

```yaml
draw:
    polygons:
        color: red
```

```yaml
draw:
    polygons:
        color: '#ff00ff'
```

```yaml
draw:
    polygons:
        color: function() { return [$zoom, .5, .5]; }
```

```yaml
draw:
    points:
        color: [1.0, .5, .5, .5] # 50% alpha
```

####`extrude`
Optional _boolean_, _number_, _[min, max]_, or _function_ returning any of the previous values. No default. Units are in meters.

Applies to `polygons` and `lines`. Extrudes features drawn with the `polygons` draw style into 3D space along the z-axis. Raises elements drawn with the `lines` draw style straight up from the ground plane.

When the value of this parameter is:

- _boolean_: if `true`, features will be extruded using the values in the feature's `height` and `min_height` properties (if those properties exist). If `false`, no extrusion.
- _number_ or _function_: features will be extruded to the provided height in meters. Features will be extruded from the ground plane, e.g. the `min_height` will be 0.
- _[min, max]_ array: features will be extruded from the provided `min` height in meters, to the provided `max` height in meters, e.g. `extrude: [50, 100]` will draw a polygon volume starting 50m above the ground, extending 100m high.

Since features drawn as `lines` have no height (e.g. they are flat 2D objects), they do not use the `min_height` values. They are simply raised to the specified `height`.

####`font`
Optional element. Defines the start of a font style block. (See [font-parameters](draw.md#font-parameters).)

Applies to the `text` style.

####`interactive`
Optional _boolean_ or _function_ returning `true` or `false`. Default is `false`.

Applies to all _draw styles_. When `true`, activates _Feature Selection_, allowing this drawing of the feature to be queried via the [JavaScript API](Javascript-API.md) (see [getFeatureAt](Javascript-API.md#getfeatureatpixel).)

Multiple draw rules can create multiple drawings of one feature. Only those drawings with `interactive: true` in their rule will be available to query.

```yaml
draw:
    polygons:
        interactive: true
```

####`join`
Optional _string_, one of `bevel`, `round`, or `miter` following the [SVG protocol](http://www.w3.org/TR/SVG/painting.html#StrokeLinecapProperty). Default is `miter`.

Applies to `lines`. Sets the shape of joints in multi-segment lines.

```yaml
draw:
    lines:
        color: black
        join: round
```

####`max_lines`
Optional _integer_. No default.

Applies to the `text` style. When the `text_wrap: true` parameter is present, `max_lines` sets the maximum number of lines that a text label is allowed to occupy. If a label would wrap onto more lines, the label is truncated with a `…` character at the end of the last visible word.

```yaml
draw:
    text:
         text_source: function(){ return "This is a very very very very very very very long label." }
         text_wrap: true
         max_lines: 2
```

####`miter_limit`
Optional _integer_. Default is 3.

Applies to `lines` with a `join` parameter set to "miter". When the length of a miter join is longer than the ratio of the `miter_limit` to the width of the line, that join is converted from a "miter" to a "bevel". This prevents excessively "spiky" corners on sharply curved lines.

Higher values allow sharper corners. Lower values result in more beveled corners, which produces a comparatively softer line shape.

```yaml
draw:
   lines:
      color: red
      width: 5px
      miter_limit: 2
```

####`move_into_tile`
[[JS-only](https://github.com/tangrams/tangram)] Optional _boolean_. Default is _true_.

Applies to `text` styles. Moves the label into the tile if the label would otherwise cross a tile boundary.

Note that this parameter is not available for `points` styles, nor for text labels attached to points.

####`offset`
Optional _[float x, float y]_ _array_ or _stops_, in `px`. No default.

Applies to styles with a `points` or `text` base. Moves the feature from its original location. For `points`, and `text` labels of point features, the offset is in *screen-space*, e.g. a Y offset of 10px will move the point or label 10 pixels down on the screen.

For labels of line features, the offset follows the *orientation of the line*, so a -10px offset will move the label 10 pixels *above* the line ("up" relative to the line). For example, line label offsets are useful for placing labels on top of or underneath roads or administrative borders.

Drawing points for POIs:

```yaml
pois:
    draw:
        points:
            # moves the point 10 pixels up in screen-space
            offset: [0px, -10px]
```

Drawing labels for POI points:

```yaml
pois:
    draw:
        text:
            # moves the point 10 pixels down in screen-space
            offset: [0px, 10px]
```

Drawing labels for road lines:

```yaml
roads:
    draw:
        text:
            # moves the label 12 pixels above the line
            offset: [0px, -12px]
```

Using _stops_ allows different `offset` values at different zooms. This can be used in conjunction with _anchor_ to position text and sprites adjacent to each other correctly when the sprite's size is interpolating across zooms.

```yaml
roads:
    draw:
        text:
            offset: [[13, [0, 6px]], [15, [0, 9px]]]
```

####`order`
Required _integer_ or _function_. No default.

Applies to the _polygon_ and _lines_ styles, by default, and to the `points` and `text` styles when the `inlay` _draw style_ is used.

Sets the drawing order of the _draw style_, to be used in case of z-depth collisions (when two features are at the same "z" height in space). In this case, higher-ordered layers will be drawn over lower-ordered layers. Child layer settings override parent layer settings.

```yaml
layers:
    roads:
        draw:
            lines:
                order: 1
        sublayer:
            draw:
                lines:
                    order: 2   # this layer's order is now 2
```

Note that by default, `points` and `text` layers are drawn with the `overlay` _draw style_, which relies on collision tests to determine draw order, as determined by a feature's [`priority`](draw.md#priority).

####`outline`
Optional element. Defines the start of an outline style block.

Applies to `lines`. Draws an outline around the feature. `outline` elements can take any `lines` style parameters.

####`placement`
Optional _string_, one of `vertex`, `spaced`, `midpoint`, or `centroid`. Defines the placement method of one or more points, when a `points`-based style is used to draw line or polygon features. Default is `vertex`.

- `placement: vertex`: place points at line/polygon vertices
- `placement: midpoint`: place points at line/polygon segment midpoints (better for road shields, which you want away from ambiguous intersections)
- `placement: spaced`: place points along a line/polygon at fixed intervals defined in pixels with `placement_spacing` (useful for symbols like one-way street arrows where consistent spacing is desirable)
- `placement: centroid`: place points at polygon centroids (not applicable to lines)

####`placement_min_length_ratio`
Optional _number_, _stops_, or _function_. Default is `1`. No units.

Applies to `points` styles used to draw line or polygon features, when the `placement` parameter is set to `spaced` or `midpoint`. Specifies the minimum line segment length as a ratio to the size (greater of width or height) of the point being placed. This prevents points from being drawn on line segments which are smaller than the point itself (for example, a road shield bigger than the road it is labeling).

Examples:

- `placement_min_length_ratio: 1` (default value) will only place points on line segments that are at least as long as the point itself (the point must fit 100% along the line segment)
- `placement_min_length_ratio: 0` disables this behavior by allowing a point to place on a line segment of any length (minimum length of 0).
- `placement_min_length_ratio: 2` requires the line segment to be at least twice as long as the point
- `placement_min_length_ratio: 0.5` requires the line segment to be only 50% as long as the point

####`placement_spacing`
Optional _integer_, _stops_, or _function_. Units are `px`. Default is `80px`.

Applies to `points` styles, when `placement: spaced` is defined.

####`priority`
Optional _integer_ or _function_. Default is the local system's max integer value.

Applies to `points` and `text`. Sets the label priority of the feature. _functions_ must return integers.

Lower values will have higher priority, e.g. `priority: 1` labels will be drawn before those with `priority: 2`; labels are drawn in a "first-come-first-drawn" method, so earlier labels are more likely to fit in the available space.

For example, to set a `places` labels to have priority over others:
```yaml
draw:
    text:
        priority: 1
```

Here's one way to set a label's priority based on the area of the labeled feature:
```yaml
draw:
    text:
        priority: function() { return Math.min(10 - Math.floor(feature.area / 1000), 10); }
```

####`repeat_distance`
Optional _number_, in `px`. Default is `256px`.

Applies to `text`. Specifies minimum distance between labels in the same `repeat_group`, measuring from the center of each label. Only applies per tile – labels may still be drawn closer than the `repeat_distance` across a tile boundary.

```yaml
draw:
   text:
      repeat_distance: 100px # label can repeat every 100 pixels
      ...
```

```yaml
draw:
   text:
       repeat_distance: 0px # labels can repeat anywhere
      ...
```

####`repeat_group`
Optional _string_. No default.

Applies to `text`. Allows the grouping of different label types for purposes of fine-tuning label repetition. By default, all labels with the same set `draw` layer and label text belong to the same `repeat_group`.


For example: labels from the two layers below can be drawn near each other, because they are in different repeat groups by default:

```yaml
roads:
   major_roads:
      filter: { kind: major_road }
      draw:
         text:
            ...
   minor_roads:
      filter: { kind: minor_road }
      draw:
         text:
            ...
```

However, labels in the sub-layers below won't repeat near each other, because they have been placed in the same `repeat_group`:

```yaml
roads:
   draw:
      text:
         repeat_group: roads-fewer-labels
   major_roads:
      filter: { kind: major_road }
      draw:
         text:
            ...
   minor_roads:
      filter: { kind: minor_road }
      draw:
         text:
            ...
```

####`required`
Optional _boolean_. Default is `false`.

Applies to _text_ blocks under _point_ styles.

When `true`, stipulates that any _text_ attached to a _point_ must draw with the point. When `false`, a _point_ and associated _text_ will be tested for collisions separately, and if the _text_ collides, the _point_ will be drawn alone.

Note that attached _text_ will never draw without its _point_.

####`size`
Optional _number_, in `px` or _stops_. Default is `32px`.

Applies to `points`.

```yaml
draw:
    points:
        size: 32px
        sprite: museum
```

```yaml
draw:
    points:
        size: [[13, 64px], [16, 18px], [18, 22px]]
        sprite: highway
```

####`sprite`
Optional _string_, one of any named `sprites` in the style's `texture` element, or a _function_ returning such a string.

Applies to `points`. Sets the `sprite` to be used when drawing a feature.

```yaml
draw:
    points:
        size: 32px
        sprite: museum
```

```yaml
draw:
    points:
        size: 32px
        sprite: function() { return feature.kind } # look for a sprite matching the feature's 'kind' property
```

Note that if any `sprites` are defined for a texture, a `sprite` must be declared for any _points_ drawn with that texture, or nothing will be drawn.

####`sprite_default`
Optional _string_. Sets a default sprite for cases when the matching function fails.

Applies to `points`.

```yaml
poi-icons:
    draw:
        points:
            sprite: function() { return feature.kind }
            sprite_default: generic
```

####`style`
Optional _string_, naming a style defined in the [`styles`](styles.md) block.

Applies to all _draw groups_.

Sets the rendering style used for the `draw` group (which defaults to a style matching the name of the draw group, if one exists). See [`draw`](draw.md#draw).

```yaml
draw:
    polygons:
        style: dots
    ...
```

####`text`
Optional _block_. Declares the beginning of a `text` block of a `points` style.

Applies to _points_ styles only. (For the `text` _draw style_, see the [Styles Overview](Styles-Overview.md#text-1).)

This block allows _points_ styles to define an associated text label for each point, such as for POIs.

Text added in this way can be styled with the same syntax as the _text_ rendering style, but with different default values that take into account the "parent" point (see "[Text behavior](draw.md#text_behavior)" below).

For example, to create an icon with a _text_ label, using a style "icons" that has `base: points`:

```yaml
   draw:
      icons:
         sprite: ...
         size: 16px
         text:
            font: ...
```

#### Text behavior

The default text style behavior is adjusted to account for the parent point:
- **Anchor**:
  - `anchor` defaults to `bottom` instead of `center` (though it is possible to composite a text label over a sprite by setting `anchor: center` and `collide: false`).
  - The point and text can have separate `anchor` values:
    - The `anchor` of the `text` controls the text's placement *relative to the size and position* of its parent point.
    - The `anchor` of the `points` portion moves the *entire entity* (point + text) relative to the underlying geometry point.
- **Offset**:
  - Text is automatically offset to account for its anchor relative to its parent point (see description above).
  - Further manual offset is possible with the `offset` parameter, which moves the text in screen space, e.g. text with `anchor: bottom` will automatically be placed below the sprite, and an additional `offset: [8px, 0]` in the scene file would move the text another 8 pixels to the right.
- **Priority**:
  - The text's `priority` is assigned a default value of `0.5` below the `priority` of its parent point (numerically this means the priority is `+0.5`, since lower numbers are "higher priority"). This can be explicitly overridden by setting a `priority` value in the `text` block, though the text's priority may not be set higher than that of its parent point. This is similar to `outline` handling, where the `order` of the outline cannot be higher than the line fill. (In both cases, the values are capped to their highest/lowest allowed values.)
  - For example, in this case, the icon has `priority: 3`, so the text portion is assigned a priority of `3.5`:
   ```
      draw:
         icons:
            ...
            priority: 3
            text:
               ...
    ```
- **Collision**:
  - The point is required, but its text is optional: while the `points` portion of the style will render according to its collision test, the `text` portion will only render if **both** it and its parent point passed collision tests, e.g. if the point is occluded, then the text won't render either, even if it is not occluded.
  - Different collision behaviors can be achieved by setting the `collide: false` flag on either or both of the point and text:
    - Both `collide: true` (default): nothing will overlap, text will only be rendered if point also fits.
    - Points `collide: false`, text `collide: true`: all points will render, text will render if it fits.
    - Points `collide: true`, text `collide: false`: points will render if they fit, in which case their attached text will also render, even if it overlaps something else.
    - Both `collide: false`: all points and text should render, regardless of overlap.

####`text_source`
Optional _string_, _function_, or _array_. Default is `name`.

Applies to `text`. Defines the source of the label text.

When the value is a _string_, it must name a feature property to use as the label text. For example, the default `name` value will draw labels showing the names of features (e.g. any that have a `name` field). An example of an alternative feature property label is to label buildings with their heights:

```yaml
draw:
    text:
        text_source: height
        ...
```

When the value is a _function_, the return value will be used as the text of the label. For example, to label buildings as 'high' and 'low':

```yaml
draw:
    text:
        text_source: |
            function() {
                if (feature.height > 100) {
                    return 'high';  // features taller than 100m will be labeled 'high'
                }
                else {
                    return 'low';   // features 100m or shorter will be labeled 'low'
                }
            }
        ...
```

When the value is an _array_, each array element is evaluated as if it was a `text_source` value (meaning each element can be either a _string_ value that specifies a feature property by name, or a _function_ that returns displayable label text). The first _non-null_ evaluated source in the array is used as the label text.

The primary use case here is to support preferred language for text labels. For example:

```yaml
draw:
    text:
        text_source: [name:en, name]
```

The above example will display an English label (name:en) when available, and will fall back to the default local name when not available.

####`text_wrap`
Optional _boolean_ or _int_, in characters. Default is 15.

Enables text wrapping for labels. Wrapping is enabled by default for point labels, and disabled for line labels.

*Note:* Explicit line break characters (`\n`) in label text will cause a line break, even if `text_wrap` is disabled.

```yaml
text:
    text_wrap: true # uses default wrapping (15 characters).
    text_wrap: 10 # sets a maximum line length of 10 characters.
    text_wrap: false # disables wrapping.
```

####`tile_edges`
Optional _boolean_, one of `true` or `false`. Default is `false`.

Applies to `lines`. Enables the drawing of borders on the edges of tiles. Usually not desirable visually, but useful for debugging.

```yaml
draw:
    water:
        outline:
            tile_edges: true
```

####`transition`
[[ES-only](https://github.com/tangrams/tangram-es)] Optional _map_ , where key is one or both of `hide` and `show` and value is a _map_ of `time` to time. `time` values can be either in seconds (`s`) or milliseconds (`ms`).

Applies to `points` and `text`. Sets the transition time from `hide` to `show`.

A transition time of `0` results in an instantaneous transition between states.

```yaml
poi-icons:
    draw:
        points:
           transition:
                [show, hide]:
                    time: .5s
```

####`visible`
Optional _boolean_. Default is `true`.

If `false`, features will not be drawn.

```yaml
draw:
    lines-that-wont-draw:
        style: lines
        visible: false
```

This parameter is also available for `text` blocks attached to a `points` layer:

```yaml
draw:
    points:
        color: red
        size: 5px
        text:
            visible: false
```

As well as `outline` blocks under `lines` layers:

```yaml
draw:
    lines:
        color: white
        width: 2px
        outline:
            visible: false
```

####`width`
Required _number_, _stops_, or _function_. No default. Units are meters `m` or pixels `px`. Default units are `m`.

Applies to `lines`. Sets the width of a feature.

```yaml
draw:
    lines:
        width: 9
```

```yaml
draw:
    lines:
        width: 4px
```

```yaml
draw:
    lines:
        width: 18m
```

```yaml
draw:
    lines:
        width: function() { return $zoom / 4 * $meters_per_pixel; }
```

####`z`
Optional _number_. No default. Units are meters `m` or pixels `px`. Default units are `m`.

Applies to `polygons` and `lines`. Sets the z-offset of a feature.

```yaml
draw:
    lines:
        z: 50
```

# fonts

*This is the technical documentation for Tangram's `fonts` block. For an overview of Tangram's labeling capabilities, see the [`text`](Styles-Overview.md#text-1) entry in the [Styles Overview](Styles-Overview.md).*

##`fonts`
The `fonts` element is an optional top-level element in the [scene file](Scene-file.md). It has only one kind of sub-element: a named _font definition_.

A _font definition_ can define a font in one of two ways: through _external CSS_, or with any number of `font face definitions`.

####`external`
[[JS-only](https://github.com/tangrams/tangram)] With this method of defining a font, the value of the _font definition_ is set to "`external`":

```
fonts:
    Poiret One: external
```

This requires that a corresponding CSS declaration be made in the HTML:

`<link href='https://fonts.googleapis.com/css?family=Poiret+One' rel='stylesheet' type='text/css'>`

Tangram will identify the externally-loaded typeface by name and make it available for use in _text_ labels.

####font face definition
A _font face definition_ may be used as the value of the _font definition_. This is an object with a number of possible parameters:

  - `weight`: defaults to `normal`, may also be `bold` or a numeric font weight, e.g. `500`
  - `style`: defaults to `normal`, may also be `italic`
  - `url`: the URL to load the font from. For maximum browser compatibility, fonts should be either `ttf`, `otf`, or `woff` (`woff2` is [currently supported](http://caniuse.com/#search=woff2) in Chrome and Firefox but not other major browsers). As with other scene resources, `url` is relative to the scene file.

An example of a _font face definition_ with a single parameter, _url_:

```yaml
fonts:
    Montserrat:
        url: https://fonts.gstatic.com/s/montserrat/v7/zhcz-_WihjSQC0oHJ9TCYL3hpw3pgy2gAi-Ip7WPMi0.woff
```

Example of a _font face definition_ with multiple parameters:

```
fonts:
    Open Sans:
        - weight: 300
          url: fonts/open sans-300normal.ttf
        - weight: 300
          style: italic
          url: fonts/open sans-300italic.ttf
        - weight: 400
          url: fonts/open sans-400normal.ttf
        - weight: 400
          style: italic
          url: fonts/open sans-400italic.ttf
        - weight: 600
          url: fonts/open sans-600normal.ttf
        - weight: 600
          style: italic
          url: fonts/open sans-600italic.ttf
        - weight: 700
          url: fonts/open sans-700normal.ttf
        - weight: 700
          style: italic
          url: fonts/open sans-700italic.ttf
        - weight: 800
          url: fonts/open sans-800normal.ttf
        - weight: 800
          style: italic
          url: fonts/open sans-800italic.ttf
```

When _font definitions_ are declared in this way, the fonts from the associated _urls_ will be used when the appropriate combination of _font-family_, _style_, and _weight_ parameters are specified in a style's [`font`](draw.md#font) block:

```yaml
draw:
    text:
        font:
            family: Open Sans
            style: italic
            weight: 300
```

## `font` parameters

The `font` object has a number of unique parameters.

```yaml
draw:
    text:
        font:
            family: Arial
            size: 14px
            style: italic
            weight: bold
            fill: '#cccccc'
            stroke: { color: white, width: 2 }
            transform: uppercase
```

####`family`
Optional _string_, naming a typeface. Sets the font-family of the label. Default is `Helvetica`.

`family` can be any typeface available to the operating system. The default will be used as a fallback if the other specified families are not available.

####`fill`
Optional _color_ or _stops_. Follows the specs of [color](draw.md#color). Default is `white`.

Sets the fill color of the label.

```yaml
font:
    fill: black
```
```yaml
font:
    fill: [[14, white], [18, gray]]
```

####`size`
Optional _number_ or _stops_, specifying a font size in `px`, `pt`, or `em`. Sets the size of the text. Default is `12`. Default units are `px`.

```yaml
font:
    family: Helvetica
    size: 10px
```

```yaml
font:
    family: Helvetica
    size: [[14, 12px], [16, 16px], [20, 24px]]
```

####`stroke`
Optional _{color, width}_ or _stops_. _colors_ follow the specs of [color](draw.md#color). _width_ may be an _int_ or _stops_. No default.

Sets the stroke color and width of the label. Width is interpreted as pixels.

```yaml
font:
    stroke: { color: white, width: 2 }
```
```yaml
font:
    stroke:
        color: [[10, gray], [15, white]] # fade from gray to white
        width: [[14, 2px], [18, 6px]]    # increase stroke width at high zoom
```

####`style`
Optional _string_, specifying a font style. No default.

Currently supports only `italic`.

####`transform`
Optional _string_, one of `capitalize`, `uppercase`, or `lowercase`. Sets a text transform style. No default.

`capitalize` will make the first letter in each word uppercase. `uppercase` and `lowercase` will change all letters to be uppercase and lowercase, respectively.

####`weight`
Optional _string_ or _number_. Strings may be one of `lighter`, `normal`, `bold`, or `bolder`; integers may be any CSS-style font weight from `100`-`900`. Default is `normal`.


# materials
*This is the technical documentation for Tangram’s materials. For a conceptual overview of the material system, see the [Materials Overview](Materials-Overview.md).*

#### `material`

Optional parameter. Begins a material block under a named [style](styles.md).

```yaml
styles:
    water:
        base: polygons
        animated: true
        material:
            ambient: .7
            diffuse: [0,0,1]
            specular: white
```

## material properties

#### `diffuse`

Optional parameter. Can be a _number_ from `0`-`1`, `[R, G, B]`, `hex-color`, `css color name`, or `texture`. Defaults to the geometry's `color` value.

```yaml
styles:
    red-wall:
        base: polygons
        material:
            diffuse: red
```


#### `ambient`
Optional parameter. Can be a _number_ from `0`-`1`, `[R, G, B]`, `hex-color`, `css color name`, or _texture_. Defaults to the `diffuse` value.

```yaml
styles:
    surface:
        base: polygons
        material:
            ambient: .7
```

#### `specular`

Optional parameter. Can be a _number_ from `0`-`1`, `[R, G, B]`, `hex-color`, `css color name`, or _texture_. Defaults to `[1.0, 1.0, 1.0]`.

```yaml
styles:
    water:
        base: polygons
        material:
            ambient: .7
            diffuse: [0,0,1]
            specular: white
            shininess: 2.0
```

#### `shininess`

Optional _number_. Defaults to `0.2`.

```yaml
styles:
    water:
        base: polygons
        material:
            ambient: .7
            diffuse: [0,0,1]
            specular: white
            shininess: 2.0
```

#### `normal`

Optional parameter. Begins a `normal` texture block. Requires `texture` and `mapping` parameters. All the mapping parameters may be applied to this object except `mapping: spheremap`. No default.

```yaml
material:
    ambient: .7
    normal:
        texture: materials/bricks.png
        mapping: uv
```

### Textures

`ambient`, `diffuse` and `specular` properties can be defined as a texture map instead of a color. When a texture is used in this way, a number of other parameters may be used to modify its display.

#### `texture`

Optional _named texture_ or _URL_. No default.

For more, see [textures#texture](textures.md#texture).

#### `mapping`
Optional _string_, one of `uv`, `planar`, `triplanar`, or `spheremap`. Default is `triplanar` for `normal` textures and `spheremap` for all others.

The `spheremap` mapping can't be used with a `normal` map.

```yaml
material:
    diffuse:
        texture: ./material/rock.jpg
        mapping: uv
```

#### `scale`

Optional _number_ or _2D vector_. `number` or `[x,y]`. Defaults to `[1,1]`.

Sets a scaling value for the texture. Does not work with `uv` mapping.

```yaml
material:
    diffuse:
        texture: ./material/rock.jpg
        mapping: planar
        scale: 2.0
```

#### `amount`

Optional _number_ or _3D vector_. `number` or `[r,g,b]`. Defaults to `1`.

This value is a multiplier on the effect of the texture – it can be thought of as the texture's opacity.

```yaml
material:
    ambient: .5
    diffuse:
        texture: ./material/rock.jpg
        mapping: uv
        scale: 2.0
        amount: 0.5
```

See also: [texture parameters](textures.md#texture-parameters).

*This is the conceptual overview for Tangram's materials system. For technical reference, see the [Materials page](materials.md).*

Materials describe how an object responds to illumination by [lights](Lights-Overview.md). In the [OpenGL lighting model](https://en.wikipedia.org/wiki/Blinn%E2%80%93Phong_shading_model), lights can emit ***diffuse***, ***ambient***, or ***specular*** light components (often known as "terms"), and the properties of a material describe how (or whether) an object will reflect those terms.

The most common material properties control the reflection of those three terms, and share their names:

###`diffuse`
This is the primary color of an object as it would appear in pure white light, in the absence of highlights. By default: `diffuse: white`.

```yaml
lights:
    light1:
        type: point
        position: [1,1,2.4]
        ambient: white
        diffuse: white
        specular: white

styles:
    stylename:
        material:
            diffuse: 0.5
            ambient: 0
            specular: 0
```
![](images/diffuse-surface.png)
![](images/diffuse.png)

###`ambient`
This is is the color of the object in the presence of ambient light. By default, the ambient color will be the same as the `diffuse` value, unless otherwise specified.

```yaml
lights:
    light1:
        type: point
        position: [1,1,2.4]
        ambient: white
        diffuse: white
        specular: white

styles:
    stylename:
        material:
            emission: 0
            ambient: 0.5
            diffuse: 0
            specular: 0
            shininess: 0.2
```
![](images/ambient-surface.png)
![](images/ambient-sphere.png)


###`specular`
In our lighting model, "specular" is the "highlight" color of a material. It can be thought of as the reflection of the light source itself on the surface of an object. The `shininess` parameter controls the size of the highlight: larger numbers produce smaller highlights, which makes the object appear shinier.

By default, these are set to `specular: 0` and `shininess: 0.2`

```yaml
lights:
    light1:
        type: point
        position: [1,1,2.4]
        ambient: white
        diffuse: white
        specular: white

styles:
    stylename:
        material:
            diffuse: 0.0
            ambient: 0
            specular: 0.5
        shininess: 2.0
```
![](images/specular-surface.png)
![](images/specular.png)


![](images/shininess.png)


###`emission`
When an `emission` color is set, the object will take on that color independent of any lights, including ambient, as though it is glowing (although it will not illuminate neighboring objects, as it is not a true light source). By default, it is set to `emission: 0`.

```yaml
lights:
    light1:
        type: point
        position: [1,1,2.4]
        ambient: 0
        diffuse: 0
        specular: 0

styles:
    stylename:
        material:
            emission: [.9,.9,.9]
            ambient: 0
            diffuse: 0.0
```
![](images/emission-surface.png)
![](images/emission.png)


## Textures

Material properties can be controlled with pixel-level detail when used with ***texture maps***.

![](images/earth.png)

Textures are loaded by setting the `texture` parameter to the url of an image or the name of an entry in the [`textures`](textures.md) block:

```yaml
material:
    diffuse:
        texture: ./images/grid.jpg
```

###Mapping
When using a texture, you must specify one of four `mapping` modes, which determine the method used to apply the texture to an object. In every case, texture coordinates are applied to the vertices of the geometry, and the image is drawn according to those coordinates.

### `mapping: uv`
UV mapping is related to the size and proportions of the geometry. With this method, a bounding box is applied to contiguous surfaces, and texture coordinates are applied to the corners of the bounding box. In the following example, a grid image is applied to each polygon. On larger shapes, the UVs are tiled, resulting in a tiled image.

![](images/uv-coords.png)

```yaml
material:
    diffuse:
        texture: ./material/grid.jpg
        mapping: uv
```
[ ![](images/uv.jpg) ](http://tangrams.github.io/tangram-docs/?material/uv.yaml#19/40.70533/-74.00975)

###`mapping: planar`
Planar mapping uses only 2D world coordinates. As you can see the pattern is constant across surfaces that face up but is stretched on the sides of geometries.

```yaml
material:
    diffuse:
        texture: /material/grid.jpg
        mapping: planar
        scale: 0.01
```

[ ![](images/planar.jpg) ](http://tangrams.github.io/tangram-docs/?material/planar.yaml#19/40.70533/-74.00975)

###`mapping: triplanar`
This is similar to `planar`, but along all three world-space axes. Where a face does not point directly along one axis, the result will be a blend of more than one axis; thus it is computationally more expensive.

```yaml
material:
    diffuse:
        texture: /material/grid.jpg
        mapping: triplanar
        scale: 0.01
```

[ ![](images/triplanar.jpg) ](http://tangrams.github.io/tangram-docs/?material/triplanar.yaml#19/40.70533/-74.00975)

###`mapping: spheremap`
A "spherical environment map", or "spheremap", is an unusual kind of mapping which is dependent on camera position. It uses a texture to color faces depending on their relative angle to the camera. You can think of a spheremap as a hemisphere over the scene, on which the texture has been painted – each polygon in the scene is colored depending on the part of the texture at which it points.

In this example, all polygons which face straight toward the camera will be given the color at the center of the spheremap's texture: white. All polys which face south will be tinted blue, east green, west red, north yellow, and so on.

![](images/sem.jpg)

```yaml
material:
    diffuse:
        texture: /material/sem.jpg
        mapping: spheremap
```

[ ![](images/spheremap.png) ](http://tangrams.github.io/tangram-docs/?material/spheremap.yaml#19/40.70533/-74.00975)

###Other properties
Each `texture` can also have the following properties:

* `scale`: use for `uv`, `planar` and `triplanar`. This scales the value of the texture coordinates. Usually, bigger values result in smaller textures. Can be a single float value, or a two/three dimensional value. By default: `scale: [1,1]`

* `amount`: is a three dimensional vector or single float number that multiply the value of the texture in order to modulate the amount of brightness of the texture. By default: `amount: [1,1,1]`


### Normals

The `normal` of a polygon is a three-dimensional vector describing the direction that it is considered to be facing. The direction that a 3D plane is facing may seem obvious, but most 3D engines allow a polygon's apparent direction to be changed without modifying the geometry, which is useful in many situations.

Tangram's polygon model assigns normals to the vertices at the corners of a polygon when the geometry is constructed, and these values are interpolated across the face of the polygon to calculate the normal at any given point. This information is used as part of the diffuse and specular lighting calculations.

The `material` implementation allows you to modify these normals with a "normal map" `texture`, using the `mapping` modes `uv`, `planar`, or `triplanar`. This can produce the illusion of far greater detail than exists in the model itself.

Here is an example of a normal map, produced with a third-party 3D application:

![](images/rock-small.jpg)

And here is the normal map assigned with the `uv` mapping to the building layer:

```yaml
material:
    normal:
        texture: /material/rock.jpg
        mapping: uv
    ambient: 0.8
    diffuse: 1
    specular: 0
```

[ ![](images/normals.png) ](http://tangrams.github.io/tangram-docs/?material/normals.yaml#19/40.70533/-74.00975)

#Composition

Any of these `material` properties is magical on its own, but even more sophisticated effects become possible when combining them. You will need to experiment to find the right combination to produce the effect that you want.

This example modifies the normal values of the water layer with a glsl `shader`, then applies a `spheremap` to it:

```yaml
material:
    ambient: .7
    diffuse:
        texture: /material/sky.jpg
        mapping: spheremap
shaders:
    blocks:
        global: |
                vec3 random3(vec3 c) {
                    float j = 4096.0*sin(dot(c,vec3(17.0, 59.4, 15.0)));
                    vec3 r;
                    r.z = fract(512.0*j);
                    j *= .125;
                    r.x = fract(512.0*j);
                    j *= .125;
                    r.y = fract(512.0*j);
                    return r-0.5;
                }

                const float F3 =  0.3333333;
                const float G3 =  0.1666667;
                float snoise(vec3 p) {

                    vec3 s = floor(p + dot(p, vec3(F3)));
                    vec3 x = p - s + dot(s, vec3(G3));

                    vec3 e = step(vec3(0.0), x - x.yzx);
                    vec3 i1 = e*(1.0 - e.zxy);
                    vec3 i2 = 1.0 - e.zxy*(1.0 - e);

                    vec3 x1 = x - i1 + G3;
                    vec3 x2 = x - i2 + 2.0*G3;
                    vec3 x3 = x - 1.0 + 3.0*G3;

                    vec4 w, d;

                    w.x = dot(x, x);
                    w.y = dot(x1, x1);
                    w.z = dot(x2, x2);
                    w.w = dot(x3, x3);

                    w = max(0.6 - w, 0.0);

                    d.x = dot(random3(s), x);
                    d.y = dot(random3(s + i1), x1);
                    d.z = dot(random3(s + i2), x2);
                    d.w = dot(random3(s + 1.0), x3);

                    w *= w;
                    w *= w;
                    d *= w;

                    return dot(d, vec4(52.0));
                }

        normal: |
            normal += snoise(vec3(worldPosition().xy*0.08,u_time*.5))*0.02;
```

[ ![](images/dynamic-normals.png) ](http://tangrams.github.io/tangram-docs/?material/dynamic-normals.yaml)


# textures


## Rasters
Tangram allows raster data sources to be loaded, displayed, and combined with vector data sources in a variety of ways, including with real-time image manipulation.

## Basic Raster Display

The simplest way to use raster data is to display it directly, without any combinations or modifications.

The example below loads a tiled raster data source in the scene file, under the [`sources`](sources.md) block:

```yaml
sources:
    stamen-terrain:
        type: Raster
        url: http://a.tile.stamen.com/terrain-background/{z}/{x}/{y}.jpg
```

Then it is rendered with the built-in [`raster` style](styles.md#raster), which is provided for typical rendering cases. This style generates tile-sized geometry and textures it with the appropriate raster data.

```yaml
layers:
    terrain:
        data: { source: stamen-terrain }
        draw:
            raster:
                order: 0 # draw on bottom
```

This allows the raster layer to be used as a basemap, with other vector data drawn on top.

![tangram-wed mar 30 2016 16-51-48 gmt-0400 edt](https://cloud.githubusercontent.com/assets/16733/14157176/e57c96dc-f697-11e5-9c6d-c1a47f8e4d1d.png)

## Tinting

The `raster` style can take a `color` parameter, which will be multiplied by the raster's color as a tint. This parameter's value defaults to "white" and accepts all standard `color` values including JavaScript functions.

This example darkens the underlying tiles by 50%:

```yaml
layers:
    terrain:
        data: { source: stamen-terrain }
        draw:
            raster:
                color: [0.5, 0.5, 0.5]
                order: 0 # draw on bottom
```

![tangram-wed mar 30 2016 16-56-31 gmt-0400 edt](https://cloud.githubusercontent.com/assets/16733/14157295/64e6683a-f698-11e5-9171-75adc131243f.png)

### Geometry Masking

The `raster` style can also be applied to a non-`Raster` source that has a raster sampler attached, using the [`rasters`](sources.md#rasters) parameter. In this case, the Stamen terrain is attached to and masked against the OSM landuse polygons:

```yaml
sources:
    stamen-terrain:
        type: Raster
        url: http://a.tile.stamen.com/terrain-background/{z}/{x}/{y}.jpg
    mapzen-osm:
        type: TopoJSON
        url: https://tile.mapzen.com/mapzen/vector/v1/all/{z}/{x}/{y}.topojson
        rasters: [stamen-terrain] # attach stamen terrain

layers:
   terrain:
       data: { source: mapzen-osm, layer: landuse } # render landuse layer from vector data source
       draw:
           raster:
               order: 0 # draw on bottom
```

![tangram-wed mar 30 2016 17-07-48 gmt-0400 edt](https://cloud.githubusercontent.com/assets/16733/14157713/52108590-f69a-11e5-8553-361a7893e257.png)

This technique can be used for combining shaded relief with landcover classifications. For example, here is a base terrain layer in gray, with landuse polygons tinted green:

![tangram-fri apr 01 2016 12-35-12 gmt-0400 edt](https://cloud.githubusercontent.com/assets/16733/14213503/4b24aa5a-f806-11e5-8bbc-ba3d61f33bed.png)

### Custom Styles

The `raster` style is derived from the `polygons` rendering style, and provides the same shader blocks. This allows for custom raster styles to be defined with `base: raster`. For example, this style converts raster tiles to grayscale:

```yaml
sources:
    stamen-terrain:
        type: Raster
        url: http://a.tile.stamen.com/terrain-background/{z}/{x}/{y}.jpg

styles:
    grayscale:
        base: raster
        shaders:
            blocks:
                filter: |
                    # get luminance of rgb value
                    float luma = dot(color.rgb, vec3(0.299, 0.587, 0.114));
                    color.rgb = vec3(luma);

layers:
    terrain:
        data: { source: stamen-terrain }
        draw:
            grayscale:
                order: 0
```



![tangram-wed mar 30 2016 16-59-03 gmt-0400 edt](https://cloud.githubusercontent.com/assets/16733/14157381/b90ec916-f698-11e5-8697-5e99a66faf23.png)

## Advanced Raster Styles

Styles can enable raster samplers with the `raster` parameter, which can have the following values:

- `color`: Applies the value of the raster texture as the `color` in the fragment shader. This is the most common case, and is set as the default by the `raster` rendering style.
- `normal`: To support terrain shading, there is also built-in support for applying a raster source as a normal map.
- `custom`: This value is for cases where you want access to raster samplers, but the data is not formatted for direct use as a color or normal. Mapzen's RGB-packed elevation tiles are an example; the raw data must be decoded and re-interpreted for usable results, and is not intended for display.

### Normal Maps

This example loads pre-computed "normal" tiles as a normal map, which can be lit by standard Tangram lights:

```yaml
sources:
    terrain-normals:
        type: Raster
        url: https://tile.mapzen.com/mapzen/terrain/v1/normal/{z}/{x}/{y}.png

    mapzen-osm:
        type: TopoJSON
        url: https://tile.mapzen.com/mapzen/vector/v1/all/{z}/{x}/{y}.topojson
        rasters: [terrain-normals]

styles:
    normals:
        base: polygons
        raster: normal

lights:
    point1:
        type: point

layers:
    earth:
        data: { source: mapzen-osm }
        draw:
            normals:
                color: white
                order: 0
```

![tangram-wed mar 30 2016 21-39-44 gmt-0400 edt](https://cloud.githubusercontent.com/assets/16733/14163150/7bff64d6-f6c0-11e5-9c22-555d8075b8dd.png)

###Direct Sampler Access

When a style declares `raster: custom`, any shaders defined in that style can directly sample the raster for custom effects.

This example uses the [`sampleRaster()`](styles.md#raster) method to unpack Mapzen elevation tiles for color display:

```yaml
styles:
    elevation:
        base: polygons
        raster: custom
        shaders:
            blocks:
                global: |
                    // Unpack RGB elevation
                    float unpack(vec4 h) {
                        return (h.r * 1. + h.g / 256. + h.b / 65536.);
                    }
                color: |
                    color.rgb = vec3(unpack(sampleRaster(0)));
                    color.rgb = (color.rgb - .5) * 20.; // re-scale to a visible range for contrast
```

![tangram-wed mar 30 2016 21-59-05 gmt-0400 edt](https://cloud.githubusercontent.com/assets/16733/14163364/a9429a10-f6c2-11e5-81c7-c0561e5919be.png)

### Multiple Raster Samplers

This example shows the use of two raster samplers in the same rendering style. First, sources are defined for Stamen's Watercolor and Toner tiles. To make them both available in the same rendering `style`, the watercolor source is attached as the second sampler for the toner source.

A simple `style` that does a 50/50 blend of the two samplers is then defined. Finally, the toner source is drawn with the blend style.

```yaml
sources:
    stamen-watercolor:
        type: Raster
        url: http://tile.stamen.com/watercolor/{z}/{x}/{y}.jpg
    stamen-toner:
        type: Raster
        url: http://tile.stamen.com/toner/{z}/{x}/{y}.png
        rasters: [stamen-watercolor] # add watercolor sampler alongside toner

styles:
    # blend two raster samplers together
    blend-rasters:
        base: polygons
        raster: color
        shaders:
            blocks:
                filter: |
                    color = (sampleRaster(0) + sampleRaster(1)) * 0.5;

layers:
    earth:
        data: { source: stamen-toner }
        draw:
            blend-rasters:
                order: 0
```

![tangram-wed mar 30 2016 17-20-15 gmt-0400 edt](https://cloud.githubusercontent.com/assets/16733/14158040/074abc0e-f69c-11e5-9cc5-a2852f24b46d.png)
