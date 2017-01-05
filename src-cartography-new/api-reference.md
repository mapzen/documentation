# API reference

Mapzen basemaps offer several global properties to customize and extend the map.

Not every basemap supports the full set of resources and the default styling of these assets is customized per Mapzen map style. See [Styles](styles.md) for what's supported.

As the basemaps are still in active development we recommend peggging an import to a specific major version, eg: `5`. See the [versioning](versioning.md) doc for more details.

## Language

Feature labels default to the local language used in that place but can be modified to show a specific language using [ISO 639-1](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes) two-letter language code and optional country code, for example `en` for English and less commonly `en_GB` for British English.

If you ask for a language that isn't present in the data, it will automatically fallback to the default (local) language.

### ux_language

* `ux_language`: defaults to `false`

Example Tangram usage:

```
globals:
    ux_language: fr
```

### ux_language_fallback

Because language coverage is spotty in the data, it's sometimes useful to pair with a **fallback** language.

For instance, if someone reads French but not Japanese they would prefer to see French labels in Tokyo. But since there aren't many French names available it's better to fallback to English names since they would be in the same alphabet, before falling all the way back to default (local) Japanese names.

* `ux_language_fallback`: defaults to `false`

Example Tangram usage:

```
globals:
    ux_language: fr
    ux_language_fallback: en
```

### Language codes

Common language codes values include:

- `ar` Arabic
- `zh` Chinese, traditional or simplified
- `en` English
- `fr` French
- `ru` Russian
- `es` Spanish
- `bn` Bengali
- `de` German
- `gr` Greek
- `hi` Hindi
- `id` Indonesian
- `it` Italian
- `ja` Japanese
- `ko` Korean
- `pt` Portugese
- `tr` Turkish
- `vi` Vietnamese

## Data visualization

To facilitate map customization and data visualizations several recommended sort orders are provided. The order properties abstract the values which work with specific versions of Mapzen vector tiles (see [feature ordering](https://mapzen.com/documentation/vector-tiles/layers/#feature-ordering) docs).

Example Tangram usage:

```
import: https://mapzen.com/carto/refill-style-more-labels/5/refill-style-more-labels.yaml

_layername:
    draw:
        line:
            order: global.sdk_order_over_everything_but_text_0
            width: 1px
            color: red
```

### Overlay

Your classic overlay: Over all line and polygon features, but under map labels (icons and text), and under UI elements (like route line and search result pins).

* `sdk_order_over_everything_but_text_0`: default
* `sdk_order_over_everything_but_text_1`: one above default
* `sdk_order_over_everything_but_text_2`: two above default
* `sdk_order_over_everything_but_text_3`: three above default
* `sdk_order_over_everything_but_text_4`: four above default
* `sdk_order_over_everything_but_text_5`: five above default
* `sdk_order_over_everything_but_text_6`: six above default
* `sdk_order_over_everything_but_text_7`: seven above default
* `sdk_order_over_everything_but_text_8`: eight above default
* `sdk_order_over_everything_but_text_9`: nine above default

### Basic underlay

Under roads. Above borders, water, landuse, and earth.

* `sdk_order_under_roads_0`: default
* `sdk_order_under_roads_1`: one above default
* `sdk_order_under_roads_2`: twp above default
* `sdk_order_under_roads_3`: three above default
* `sdk_order_under_roads_4`: four above default
* `sdk_order_under_roads_5`: five above default
* `sdk_order_under_roads_6`: six above default
* `sdk_order_under_roads_7`: seven above default
* `sdk_order_under_roads_8`: eight above default
* `sdk_order_under_roads_9`: nine above default

### Under water

Above earth and most landuse.

* `sdk_order_under_water_0`: default
* `sdk_order_under_water_1`: one above default
* `sdk_order_under_water_2`: two above default
* `sdk_order_under_water_3`: three above default
* `sdk_order_under_water_4`: four above default
* `sdk_order_under_water_5`: five above default
* `sdk_order_under_water_6`: six above default
* `sdk_order_under_water_7`: seven above default
* `sdk_order_under_water_8`: eight above default
* `sdk_order_under_water_9`: nine above default

### Under everything

Tip: disable earth layer.

* `sdk_order_under_everything_0`: default
* `sdk_order_under_everything_1`: one above default
* `sdk_order_under_everything_2`: two above default
* `sdk_order_under_everything_3`: three above default
* `sdk_order_under_everything_4`: four above default
* `sdk_order_under_everything_5`: five above default
* `sdk_order_under_everything_6`: six above default
* `sdk_order_under_everything_7`: seven above default
* `sdk_order_under_everything_8`: eight above default
* `sdk_order_under_everything_9`: nine above default

## Transit overlay

Some basemap styles support transit overlays.

* `sdk_transit_overlay`: default `false`

Example Tangram usage:

```
import: https://mapzen.com/carto/bubble-wrap-style/bubble-wrap.yaml

globals:
    sdk_transit_overlay: true
```

## Default draw styles

Custom draw styles for icons, point, line, and polygon overlays on the map. These set the feature order and blend order to be a standard overlay.

### Icons

* **draw style:** `icons`
* **sprite:** multiple sprites supported in the `pois` texture, see [icons](icons.md)

### Points

* **draw style:** `sdk-point-overlay`
* **sprite:** `ux-search-active`

### Lines

* **draw style:** `sdk-line-overlay`

### Polygons

* **draw style:** `sdk-polygon-overlay`


## User experience

Several special data sources, draw styles, and sprites (icons) are provided for building and customizing mapping applications. These set the feature order and blend order to be above all other map elements.

If you add a any of the following named data sources to the scene file (or update features into the named data source) the draw style will activate automatically.

### Current location

* **data source:** `mz_current_location`
* **draw style:** `ux-location-gem-overlay`
* **sprite:** `ux-current-location`

### Dropped pin

* **data source:** `mz_dropped_pin`
* **draw style:** `ux-icons-overlay`
* **sprite:** `ux-search-active`

### Search results

* **data source:** `mz_search_result`
* **draw style:** `ux-icons-overlay`
* **sprite:** `ux-search-active`

When a search feature is marked `state: inactive`, the following resources is used:

* **sprite:** `ux-search-inactive`

### Routing

#### Route line

* **data source:** `mz_route_line`
* **draw style:** `ux-route-line-overlay`

#### Progress along the route line

* **data source:** `mz_route_location`
* **draw style:** `ux-location-gem-overlay`
* **sprite:** `ux-route-arrow`

#### Starting location icon

* **data source:** `mz_route_start`
* **draw style:** `ux-icons-overlay`
* **sprite:** `ux-route-start`

#### Destination location icon

* **data source:** `mz_route_destination`
* **draw style:** `ux-icons-overlay`
* **sprite:** `ux-route-stop`

#### Transit route line

Each transit route segment could be a different "line" each with it's own `color` data driven styling. But some transit lines don't define a color, in those cases default to blue.

* **data source:** `mz_route_line_transit`
* **data source feature property:** `color`
* **draw style:** `ux-transit-line-overlay`

#### Transit stop

For major transit stops related to onboarding, offboarding, and transfers. If pass-thru stops are provided in the data source they will also be rendered (but are not in the general Mapzen Turn-by-Turn response).

* **data source:** `mz_route_transit_stop`
* **draw style:** `ux-icons-overlay`
* **sprite:** `ux-transit-stop`

#### Dashed route line

Used to show walking segments of multi-modal routes.

* **data source:** `mz_dash_line`
* **draw style:** `ux-route-line-dash-overlay`
