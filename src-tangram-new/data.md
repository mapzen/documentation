# Data in Tangram

## layers

*This is the technical documentation for the "layers" block in Tangram's scene file. For a conceptual overview of the way Tangram applies styles to data, see the [Filters Overview](Filters-Overview.md) and the [Styles Overview](Styles-Overview.md).*

####`layers`
The `layers` element is a required top-level element in the [scene file](Scene-file.md). It has only one kind of sub-element: a *layer name*, which defines individual layers with a layer filter.

```yaml
layers:
    earth:
        ...
```

### layer name
Required _string_. Can be anything. No default.

```yaml
layers:
    landuse:
        ...
```
## layer parameters

####`data`
Required parameter. Defines the beginning of a [data block](#data-parameters). Usable by top-level layers only. No default.
```yaml
layers:
    landuse:
        data: { source: osm }
```

####`filter`
Optional _object_ or _function_. No default.

A `filter` element may be included once in any layer or sublayer. Only features matching the filter will be included in that layer (and its sublayers). For more on the filtering system, see [Filters Overview](Filters-Overview.md).

```yaml
layers:
    roads:
        data: { source: osm }
        filter: { kind: highway }
```

####`visible`
Optional _Boolean_. Allows layer to be turned off and on. Default is `true`.

```yaml
layers:
    landuse:
        data: { source: osm }
        visible: false
```

####`draw`
Required parameter. Defines the beginning of a [draw block](#draw-parameters). For draw parameters, see the [draw](draw.md) entry.
```yaml
layers:
    landuse:
        data: { source: osm }
        draw:
            ...
```

####sublayer name
Optional _string_. Can be anything except the other sublayer parameters: "draw", "filter", and "properties". No default.

Defines a _sublayer_. Sublayers can have all `layer` parameters except `data`, and can be nested.

All parameters not explicitly defined in a sublayer will be inherited from the parent layer, including `draw`, `properties`, and `filter` definitions. Note that `filter` objects in different sublayers may match simultaneously – see the [Filters Overview](Filters-Overview.md).

```yaml
layers:
    landuse:
        data: { source: osm }
        filter: ...
        draw: ...
        sublayer:
            filter: ...
            draw: ...
        sublayer2:
            filter: ...
            draw: ...
            subsublayer:
                filter: ...
                draw: ...
```

## `data` parameters

####`source`
Required _string_, naming one of the sources defined in the [sources](sources.md) block.

```yaml
data:
    source: osm
```

####`layer`
Optional _string_ or _[strings]_, naming a top-level named object in the source datalayer. In GeoJSON, this is a _FeatureCollection_. If a `layer` is not specified, the _layer name_ will be used.
```yaml
data:
    source: osm
    layer: buildings
```

The above `layer` refers to the below object:
```json
{"buildings":
    {"type":"FeatureCollection","features":[
        {"geometry":"..."}
    ]}
}
```

Because the _layer name_ is the same as the name of the GeoJSON object, the `data` object's `layer` parameter can be omitted. Most of our examples, use this form.
```yaml
layer:
    buildings:
        data: { source: osm }
```

When an array of layer names may is used as the value of the `layer` parameter, the corresponding data layers will be combined client-side. This allows easy styling of multiple layers at once:

```yaml
layer:
    labels:
        data: { source: osm, layer: [buildings, pois] }
        filter: { name: true }
        draw:
            text:
                ...
```
The above example combines the "buildings" and "pois" layers into a new layer called "labels", for drawing with the `text` _draw style_.

## `draw` parameters

See the [draw](draw.md) entry.


## layer filters
Tangram is designed to work with vector tiles in a number of formats. Data sources are specified in the [`sources`](sources.md) block of Tangram's scene file. Once a datasource is specified, **filters** allow you to style different parts of your data in different ways.

The Tangram scene file filters data in two ways: with top-level **layer filters** and lower-level **feature filters**.

# Layer filters

Vector tiles typically contain top-level structures which can be thought of as "layers" – inside a GeoJSON file, these would be the _FeatureCollection_ objects. Inside a Tangram scene file, the [`layers`](layers.md) object allows you to split the data by layer, by matching against the layer name.

```yaml
layers:
    my-roads-layer:
        data:
            source: mapzen
            layer: roads
        draw: ...
```

Specifying `layer: roads` in the [`data`](layers.md#data) block matches this GeoJSON object:

```json
{"roads":
    {"type":"FeatureCollection","features":[
        {"geometry":"..."}
    ]}
}
```

## Layer name shortcut

If a `layer` filter is not specified, Tangram will attempt to use the _layer name_ as the filter. In this example, the layer name "roads" matches a layer in the data:

```yaml
layers:
    roads:
        data:
            source: mapzen
        draw: ...
```

# Feature filters

Once a top-level `layer` filter has been applied, feature-level [`filter`](layers.md#filter) objects can be defined to filter by feature properties, in order to further narrow down the data of interest and refine the styles applied to the data.

```yaml
layers:
    roads:
        data: { source: mapzen }

        highway:
            filter:
                kind: highway
            draw: ...
```

Here, a top-level layer named "roads" matches the "roads" layer in the "osm" data source. It has a `style` block, which will apply to all features in the "roads" layer unless it is overridden, functioning as a kind of "default" style.

Then, a _sublayer_ named "highway" is declared, with its own `filter` and `draw`. Its `draw` block will apply only to roads which match its `filter` – in this case, those with the property "kind", with a value of "highway".

## Inheritance

Higher-level filters continue to apply at lower levels, which means that higher-level `draw` parameters will be inherited by lower levels, unless the lower level explicitly overrides it.

Using sublayers and inheritance, you may specify increasingly specific filters and draw styles to account for as many special cases as you like.

# Matching

Each feature in a `layer` is first tested against each top-level `filter`, and if the feature's data matches the filter, that feature will be assigned any associated [`draw`](draw.md) styles, and passed on to any _sublayers_. If any _sublayer_ filters match the feature, that _sublayer_'s `draw` styles will overwrite any previously-assigned styling rules for those matching features, and so on down the chain of inheritance.

Feature filters can match any named feature property in the data, as well as a few special _reserved keywords_.

## Feature properties

Feature properties in a GeoJSON datasource are listed in a JSON member specifically named "properties":

```json
{
    "type": "Feature",
    "id": "248156318",
    "properties": {
        "kind": "commercial",
        "area": 12148,
        "height": 63.4000000
    }
}
```

Analogous property structures exist in other data formats such as TopoJSON and Mapbox Vector Tiles. Tangram makes these structures available to `filter` blocks by property name, and also to any JavaScript filter functions under the `feature` keyword.

The json feature above will match these two filters:

```yaml
filter:
    kind: commercial

filter: function() { return feature.kind == "commercial"; }
```

The simplest type of feature filter is a statement about one named property of a feature.

A filter can match an exact value:

```yaml
filter:
    kind: residential
```

any value in a list:

```yaml
filter:
    kind: [residential, commercial]
```

or a value in a numeric range:

```yaml
filter:
    area: { min: 100, max: 500 }
```

A Boolean value of "true" will pass a feature that contains the named property, ignoring the property's value. A value of "false" will pass a feature that does _not_ contain the named property:

```yaml
filter:
    kind: true
    area: false
```

To match a property whose value is a boolean, use the list syntax:

```yaml
filter:
    boolean_property: [true]
```

A feature filter can also evaluate one or more properties in a JavaScript function:

```yaml
filter:
    function() { return feature.area > 100000 }
```

For example, let's say we have a feature with a single property called "height":

```json
{ "type":"Feature", "properties":{ "height":200 } }
```

This feature will match these filters:

```yaml
filter: { height: 200 }
filter: { height: { max: 300 } }
filter: { height: true }
filter: { unicycle: false }
filter: function() { return feature.height >= 100; }
filter: function() { return true; }
```

and will not match these filters:

```yaml
filter: { height: 100 }
filter: { height: { min: 300 } }
filter: { height: false }
filter: { unicycle: true }
filter: function() { return feature.height <= 100; }
filter: function() { return false; }
```

## Keyword properties

The keyword `$geometry` matches the feature's geometry type, for cases when a FeatureCollection includes more than one type of kind of geometry. Valid geometry types are:

- `point`: matches `Point`, `MultiPoint`
- `line`: matches `LineString`, `MultiLineString`
- `polygon`: matches `Polygon`, `MultiPolygon`

```yaml
filter: { $geometry: polygon }                      # matches polygons only

filter: { $geometry: [point, line] }                # matches points and lines, but not polygons

filter: function() { return $geometry === 'line' }  # matches lines only
```

The keyword `$layer` matches the feature's layer name, for cases when a data layer includes more than one source layer. In the case below, a data layer is created from two source layers, which can then be separated again by layer for styling:

```yaml
labels:
    data: { source: mapzen, layer: [places, pois] }
    draw:
        ...
    pois-only:
        filter: { $layer: pois }            # matches features from the "pois" layer only
        draw:
            ...
```

The keyword `$zoom` matches the current zoom level of the map. It can be used with the `min` and `max` functions.

```yaml
filter: { $zoom: 14 }

filter: { $zoom: { min: 10 } }              # matches zooms 10 and up

filter:
    $zoom: { min: 12, max: 15 }             # matches zooms 12-14

filter: function() { return $zoom <= 10 }   # matches zooms 10 and below
```

## `label_placement`

The `label_placement` property is given only to special auto-generated _point_ geometries, and may be used for placing a single label in the center of a polygon, instead of once per tile. To add these _points_ to a datasource, add the `generate_label_centroids` property to its [source] block:

```yaml
sources:
    mapzen:
        type: TopoJSON
        url:  https://tile.mapzen.com/mapzen/vector/v1/all/{z}/{x}/{y}.topojson
        generate_label_centroids: true

layers:
    landuse:
        data: {source: mapzen}
        points:
            filter:
                label_placement: true
```

See [`generate_label_centroids`](sources.md#generate_label_centroids)

## Filter functions

### Range functions

The filter functions `min` and `max` are equivalent to `>=` and `<` in a JavaScript function, and can be used in combination.

```yaml
filter:
    area: { max: 1000 } }      # matches areas up to 1000 sq meters

filter:
    height: { min: 70 } }       # matches heights 70 and up

filter:
    $zoom: { min: 5, max: 10 }  # matches zooms 5-9
```

### `px2`

Range functions can also accept a special screen-space area unit called `px2`:

```yaml
filter: { area: { min: 500px2 } }
```

This example filters the feature's area property by the number of _square mercator meters_ that cover a 500 pixel screen area at the current zoom level. This means that the area property must be in square mercator meters, as the property provided by Mapzen vector tiles is.

As with other pixel-based values in the scene file, the `px2` units are expressed in _logical pixels_ (or "CSS pixels"), meaning they are interpreted at a pixel density of 1, and are automatically scaled up for higher density displays.

The `px2` unit syntax can be used to simplify more cumbersome per-zoom filters.

Note that a `px2` area filter can only be applied if the data source already contains a suitable area property – it does not need to be named area, as any property name can be specified in the filter, but it must already exist in the data source.

### Boolean functions

The following Boolean filter functions are also available:

- `not`
- `any`
- `all`
- `none` (a combination of `not` and `any`)

`not` takes a single filter object as its input:

```yaml
filter:
    not: { kind: restaurant }

filter:
    not: { kind: [bar, pub] }
```

`any`, `all`, and `none` take lists of filter objects:

```yaml
filter:
    all:
        - { kind: museum }
        - function() { return feature.area > 100000 }

filter:
    any:
        - { height: { min: 100 } }
        - { name: true }

filter:
    none:
        - { kind: cemetery }
        - { kind: graveyard }
        - { kind: aerodrome }
```

## Lists imply `any`, Mappings imply `all`

A _list_ of several filters is a shortcut for using the `any` function. These two filters are equivalent:

```yaml
filter: [ kind: minor_road, railway: true ]

filter:
    any:
        - kind: minor_road
        - railway: true
```

A _mapping_ of several filters is a shortcut for using the `all` function. These two filters are equivalent:

```yaml
filter: { kind: hamlet, $zoom: { min: 13 } }

filter:
    all:
        - kind: hamlet
        - $zoom: { min: 13 }
```

## Matching collisions

In some cases, filters at the same level may return overlapping results:

```yaml
roads:
    data: { source: mapzen }
    highway:
        filter: { kind: highway }
        draw: { lines: { color: red } }
    bridges:
        filter: { is_bridge: yes }
        draw: { lines: { color: blue } }
```

In this case, "highways" are colored red, and "bridges" are blue. However, if any feature is both a "highway" _and_ a "bridge", it will match twice. Because YAML maps are technically "orderless", there's no way to guarantee that one of these styles will consistently be shown over the other. The solution here is to restructure the styles so that each case matches explicitly:

```yaml
roads:
    highway:
        filter: { kind: highway }
        draw: { lines: { color: red } }
        highway-bridges:
            filter: { is_bridge: yes }
            draw: { lines: { color: blue } }
    other-bridges:
        filter: { is_bridge: yes, not: { kind: highway} }
        draw: { lines: { color: green } }
```



## import

## sources
*This is the technical documentation for Tangram's `sources` block. For a conceptual overview of the way Tangram works with data sources, see the [Filters Overview](Filters-Overview.md).*

## `sources`
The `sources` element is a required top-level element in a Tangram scene file. It declares the beginning of a `sources` block. It takes only one kind of parameter: the _source name_. Any number of _source names_ can be declared.

```yaml
sources:
    # Mapzen tiles in TopoJSON format
    mapzen-topojson:
        type: TopoJSON
        url: https://tile.mapzen.com/mapzen/vector/v1/all/{z}/{x}/{y}.topojson

    # Mapzen tiles in GeoJSON format
    mapzen-geojson:
        type: GeoJSON
        url: https://tile.mapzen.com/mapzen/vector/v1/all/{z}/{x}/{y}.json

    # Mapzen tiles in Mapbox Vector Tile format
    mapzen-mvt:
        type: MVT
        url: https://tile.mapzen.com/mapzen/vector/v1/all/{z}/{x}/{y}.mvt

    # Mapzen terrain tiles
    mapzen-terrain:
        type: Raster
        url: https://tile.mapzen.com/mapzen/terrain/v1/normal/{z}/{x}/{y}.png
```

All of our demos were created using the [Mapzen Vector Tiles](https://github.com/mapzen/vector-datasource) service, which hosts tiled [OpenStreetMap](http://openstreetmap.org) data.

#### source names
Required _string_, can be anything. No default.

Specifies the beginning of a source block.

The source below is named `mapzen`:
```yaml
sources:
    mapzen:
        type: GeoJSON
        url: https://tile.mapzen.com/mapzen/vector/v1/all/{z}/{x}/{y}.json
```

### required source parameters
Source objects can take a number of parameters – only [`type`](#type) and [`url`](#url) are required.

#### type
Required _string_. Sets the type of the datasource. No default.

Four options are currently supported:

- `TopoJSON`
- `GeoJSON`
- `MVT` (Mapbox Vector Tiles)
- `Raster`

Note that these names are _case-sensitive_. As of v0.2, Tangram supports either tiled or untiled datasources.

Note: Tangram expects tiles in `TopoJSON` or `GeoJSON` formats to contain latitude-longitude coordinates.

#### url
Required _string_. Specifies the source's _URL_. No default.

```yaml
sources:
    mapzen:
        type: MVT
        url: https://tile.mapzen.com/mapzen/vector/v1/all/{z}/{x}/{y}.mvt
```

The URL to a tiled datasource will include special tokens ("{x}", "{z}", etc.) which will be automatically replaced with the appropriate position and zoom coordinates to fetch the correct tile at a given point. Use of `https://` (SSL) is recommended when possible, to avoid browser security warnings: in cases where the page hosting the map is loaded securely via `https://`, most browsers require other resources including tiles to be as well).

Various tilesources may have differing URL schemes, and use of `http://` may still be useful for local development, for example:

```yaml
sources:
    local:
        type: GeoJSON
        url: http://localhost:8000/tiles/{x}-{y}-{z}.json
```

An untiled datasource will have a simple _URL_ to a single file:

```yaml
sources:
    overlay:
        type: GeoJSON
        url: overlay.json
```

Relative _URLs_ are relative to the scene file's location. In the above example, "overlay.json" should be in the same directory as the scene file.

##### layers
Depending on the datasource, you may be able to request specific layers from the tiles by modifying the url:

```yaml
# all layers
https://tile.mapzen.com/mapzen/vector/v1/all/{z}/{x}/{y}.json

# building layer only
https://tile.mapzen.com/mapzen/vector/v1/buildings/{z}/{x}/{y}.topojson
```

##### curly braces
When tiles are requested, Tangram will parse the datasource url and interpret items in curly braces according to the convention used by Leaflet and others.

```yaml
mapzen:
    type: TopoJSON
    url: https://tile.mapzen.com/mapzen/vector/v1/all/{z}/{x}/{y}.topojson
```

In the example above, Tangram will automatically replace `{x}`, `{y}`, and `{z}` with the correct tile coordinates and zoom level for each tile, depending on which tiles are visible in the current scene, and the result will be something like:

`https://tile.mapzen.com/mapzen/vector/v1/all/16/19296/24640.topojson`

##### access tokens
The `url` may require an access token:

```yaml
mapbox:
    type: MVT
    url: https://a.tiles.mapbox.com/v4/mapbox.mapbox-streets-v6-dev/{z}/{x}/{y}.vector.pbf?access_token=...
```

### optional source parameters

#### `bounds`
Optional _array of lat/lngs_. No default.

The `bounds` of a data source are specified as a single, flattened 4-element array of lat/lng values, in the order `[w, s, e, n]`. When specified, tiles for this datasource will not be requested outside of this bounding box.

```yaml
sources:
    mapzen:    
        type: TopoJSON
        url: https://tile.mapzen.com/mapzen/vector/v1/all/{z}/{x}/{y}.topojson
        bounds: [-74.1274, 40.5780, -73.8004, 40.8253] # [w, s, e, n]
```

#### `enforce_winding`
*This parameter has been deprecated as of Tangram JS v0.5.1. The deprecation is backwards compatible, and data sources will behave correctly with or without this parameter*.

#### `scripts`
[[JS-only](https://github.com/tangrams/tangram)] Optional _[strings]_, specifying the URL of a JavaScript file.

These scripts will be loaded before the data is processed so that they are available to the [`transform`](sources.md#transform) function.

```yaml
scripts: [ 'https://url.com/js/script.js', 'local_script.js']
```

#### `extra_data`
[[JS-only](https://github.com/tangrams/tangram)] Optional _YAML_, defining custom data to be used in post-processing.

This data is made available to `transform` functions as the second parameter. `extra_data` could also be manipulated dynamically at run-time, via the `scene.config` variable (the serialized form of the scene file); for example, `scene.config.sources.source_name.extra_data` could be assigned an arbitrary JSON object, after which `scene.rebuild()` could be called to re-process the tile data.

```yaml
extra_data:
    Broadway: Wide St.
    Wall St.: Tall St.
    Water St.: Wine St.

transform: |
    function (data, extra_data) {
        // manipulate data with extra_data
        var keys = Object.keys(extra_data);
        if (data.roads) {
            data.roads.features.forEach(function(feature) {
                if (extra_data[feature.properties.name]) {
                    feature.properties.name = extra_data[feature.properties.name]; // selectively rename features
                }
            });
        }
        return data;
    }
```

#### `filtering`
Optional _string_, one of `mipmap`, `linear`, or `nearest`. Default is `mipmap` for images with dimensions which are powers of two (e.g. 256 or 512) and `linear` for non-power-of-two images.

Sets a texture filtering mode to be set for `Raster` sources only.

Raster tiles are generally power-of-two. Other sizes are scaled to fit the tile square.

Setting `filtering: nearest` allows for the raster tiles to be pixelated when scaled past their max_zoom.

#### `generate_label_centroids`
Optional _boolean_. Default is _false_.

A toggle for creating labels at the centroids of polygons for non-tiled GeoJSON and TopoJSON sources.

When set to `true` new _point_ geometries will be added to the data source, one located at the geometrical center (or "centroid") of every _polygon_. Each point will receive a [`{"label_placement" : "true"}`](Filters-Overview.md#label_placement) property which may be filtered against, as well as a copy of the associated feature's properties.

This allows a single label to be placed at the centroid of a polygon region, instead of multiple labels when the polygon is tiled.

If the feature in question is a multipolygon, the centroid _point_ will be added to the largest polygon in the group.

```yaml
sources:
    local:
        type: GeoJSON
        url: https://tile.mapzen.com/mapzen/vector/v1/all/{z}/{x}/{y}.json
        max_zoom: 15
        generate_label_centroids: true
```

#### `max_display_zoom`, `min_display_zoom`
Optional _integer_. No default.

`max_display_zoom` sets the highest zoom level which will be requested from the datasource. `mix_display_zoom` sets the lowest zoom level which will be requested from the datasource. Outside of this range, tiles will not be requested nor displayed.

```yaml
sources:
    local:
        type: GeoJSON
        url: https://tile.mapzen.com/mapzen/vector/v1/all/{z}/{x}/{y}.json
        max_display_zoom: 9
        max_display_zoom: 18
```

#### `max_zoom`
Optional _integer_. Default is _18_.

Sets the highest zoom level which will be requested from the datasource. At higher zoom levels, the data from this zoom level will continue to be displayed.

```yaml
sources:
    local:
        type: GeoJSON
        url: https://tile.mapzen.com/mapzen/vector/v1/all/{z}/{x}/{y}.json
        max_zoom: 15
```

#### `rasters`
Optional _list_ of `Raster` sources to be "attached" to the `source`. No default for non-`Raster` sources. A `Raster` source is available to itself by default.

Attaching a `Raster` to another `source` makes that `Raster` available to any shaders used to draw that `source` via the [`sampleRaster()`](styles.md#raster) function.

(See [Geometry Masking](Raster-Overview.md#Geometry-Masking) for examples.)

**Note:** a simple _string_ value will not function correctly – even a single `raster` must be in _list_ format, e.g. surrounded by square brackets:

```yaml
sources:
  terrain-normals:
      type: Raster
      url: https://tile.mapzen.com/mapzen/terrain/v1/normal/{z}/{x}/{y}.png
```

When a `Raster` source itself has additional raster sources set in the `rasters` property, the "parent" source will be the first raster sampler, and those from `rasters` will be added afterward. (essentially it is as if the parent source was inserted as the first item in the rasters array).

For more, see the [Raster Overview](Raster-Overview.md).

####`transform`
[[JS-only](https://github.com/tangrams/tangram)] Optional _function_.

This allows the data to be manipulated *after* it is loaded but *before* it is styled. Transform functions are useful for custom post-processing, either where you may not have direct control over the source data, or where you have a dynamic manipulation you would like to perform that incorporates other data separate from the source. The `transform` function is passed a `data` object, with a GeoJSON FeatureCollection assigned to each layer name, e.g. `data.buildings` would provide data from the `buildings` layer, with individual features accessible in `data.buildings.features`.

The `transform` function is supported for all tiled and untiled GeoJSON, TopoJSON, and MVT data sources.

```yaml
transform: |
    function (data) {
        // manipulate data
        if (data.roads) {
            data.roads.features.forEach(function(feature) {
                if (feature.properties.name) {
                    feature.properties.name += ' test!'; // add a string to each feature name
                }
            });
        }
        return data;
    }
```

#### `url_params`
Optional _object_. No default.

The `url_params` block can contain any number of key-value pairs which will be appended to the source `url`. This allows the dynamic definition of parameters such as queries or api keys.

```yaml
sources:
    vector-tiles:
        url: https://tile.mapzen.com/mapzen/vector/v1/all/{z}/{x}/{y}.topojson
        url_params:
            api_key: vector-tiles-h2UV1dw
```
