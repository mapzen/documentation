# The Scene file


## Required Elements in Tangram

## `scene`
The `scene` element is an optional top-level element in a Tangram scene file. It declares the beginning of a `sources` block. It allows various scene-wide options to be set:

- `background`
- `animated`

#### `background`
Optional block that can be used to set the map's background color, using a `color` property.


##### `color`
Optional _color_. Default is `[0., 0., 0.]`.

Specifies the color that will be drawn where no features are drawn. Alpha is not respected.

```yaml
scene:
    background:
        color: white
```

See also: [`color`](draw.md#color).

#### animated
Optional _boolean_, `true` or `false`. Default is `false`.

When `true`, this option forces per-frame updates.

Animated shaders will trigger redraws by default, but certain other kinds of animation – such as that made through the JavaScript API – may not. Setting this parameter may help in those cases.

```yaml
scene:
    animated: true
```

---------------------------------

The **scene file** is a [YAML](http://en.wikipedia.org/wiki/YAML) document which organizes all of the elements Tangram uses to draw a map. YAML is a data format similar in many ways to JSON, but it has some unique features which we thought made it more friendly and easy to use for our purposes. (See the [YAML](yaml.md) entry for more about those features.)

## Top-level Elements

There are a variety of top-level elements allowed in a scene file. Each defines the beginning of a _block_ named for the element.

####`cameras`
Optional element. The `cameras` block allows modifications to the view of the map.

See [Cameras Overview](Cameras-Overview.md) and [cameras](cameras.md).

####`layers`
Required element. The `layers` block divides the data into layers and assigns styling parameters.

See [Styles Overview](Styles-Overview.md) and [layers](layers.md).

####`global`
Optional element. The `global` block allows the addition of custom named parameters which can be substituted for values elsewhere in the scene file.

See [global](global.md).

####`import`
Optional element. The `import` block allows other .yaml files, containing any combination of Tangram scene blocks, specified from the top-level blocks outward, up to entire scene files, to be imported into the current scene, through a simple text-based merge.

See [import](import.md).

####`lights`
Optional element. The `lights` block allows control of the lighting of the map.

See [Lights Overview](Lights-Overview.md) and [lights](lights.md).

####`scene`
Optional element. The `scene` block sets various scene-wide parameters.

See [scene](scene.md).

####`sources`
Required element. The `sources` block identifies datasources.

See [sources](sources.md).

####`styles`
Optional element. The `styles` block defines rendering styles, which are composed of [materials](materials.md) and [shaders](shaders.md).

See [Styles Overview](Styles-Overview.md) and [styles](styles.md).

####`textures`
Optional element. The `textures` block allows for advanced configuration of textures within [materials](materials.md).

See [Materials Overview](Materials-Overview.md) and [textures](textures.md).


## The basics
To create a map, the scene file requires only:

- a data source
- data interpretation rules (filters)
- styling rules

Here's a simple scene file:

```yaml
sources:
    mapzen:
        type: TopoJSON
        url: https://tile.mapzen.com/mapzen/vector/v1/all/{z}/{x}/{y}.topojson

layers:
    earth:
        data: { source: mapzen }
        draw:
            polygons:
                order: 0
                color: darkgreen
    water:
        data: { source: mapzen }
        draw:
            polygons:
                order: 1
                color: lightblue

    roads:
        data: { source: mapzen }
        draw:
            lines:
                order: 2
                color: white
                width: 1.5px
```

In this example, all three elements are included – this will produce a map.

## global
*This is the technical documentation for Tangram's `global` block. For a conceptual overview of the Tangram scene file, see the [scene file](Scene-file.md) page.*

## `global`
The `global` element is an optional top-level element in a Tangram scene file. It declares the beginning of the `global` block. It takes only one kind of parameter: a _property_. Any number of _properties_ can be declared.

#### `property`
Optional _key/value pair_. *Key* can be any _string_, no default. *Value* can be any _object_, including another nested property, no default.

_Global properties_ are user-defined properties in the scene file that can be substituted for values elsewhere in the file. This is useful for setting a value in multiple places in the scene file simultaneously. It's also useful for setting important values at the top of the scene file, rather than inline. Examples include common colors, language preferences, or visibility flags used to tweak styles.

```yaml
global:
   labels: true # label visibility flag
```

These properties can then be substituted elsewhere in the scene file with the `global.` syntax:

```yaml
layers:
   water:
      data: { ... }
      visible: global.labels
```

```yaml
layers:
   road-labels:
      data: { ... }
      draw:
         text:
            # display labels in preferred language, fallback to default name
            text_source: [global.language, name]
```

#### nesting

Properties can be nested:

```yaml
global:
   colors: # group common colors together
      color1: red
      color2: green
      color3: blue
```

They can then be referenced with nested dot notation (`global.group.property`):

```yaml
landuse:
    data: { ... }
    draw:
        polygons:
            color: global.colors.color2 # nested property
            ...
```

#### use in functions

Global properties are available in JS function filters and properties, using the same syntax:

```yaml
layers:
   point-labels:
      data: { ... }
      draw:
         text:
            text_source: |
               function() {
                  // Make a compound label with "Preferred Name (Local Name)"
                  var preferred = feature[global.language];
                  if (preferred && preferred !== feature.name) {
                     return preferred + '\n(' + feature.name + ')';
                  }
                  return feature.name;
               }
```
