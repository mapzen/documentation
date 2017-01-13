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
    if (typeof iframe != "undefined") el.removeChild(iframe);
}
function show(el) {
    iframe = el.getElementsByTagName("iframe")[0];
    if (typeof iframe == "undefined") {
        iframe = document.createElement("iframe");
        el.appendChild(iframe);
        iframe.style.height = "100%";
        iframe.src = el.getAttribute("source");
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
                if (j != i && j != i+1) {
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

# Make a map in Tangram

[Tangram](index.md) is a 2D and 3D map renderer that allows you to make web maps with almost infinite possibilities. Tangram is built off of [WebGL](index.md#webgl) and uses a syntax style called [YAML](index.md#YAML) to control the map design with extremely fine detail, if desired. This step-by-step tutorial will walk you through making your first Tangram map.  

This tutorial uses [Tangram Play](https://mapzen.com/tangram/play), an in-browser text editor for Tangram. You can also build Tangram maps in a [text editor running a Python web server]().

To complete this tutorial, you need a [browser that supports WebGL](https://get.webgl.org/). You will need to maintain an Internet connection while you are working so you can access the map source data, which is being streamed from Mapzen's servers. It should take you about an hour to complete the exercise and you'll create a map that looks like this:

<iframe class="demo-wrapper" src="https://mapzen.com/tangram/play/?scene=https%3A%2F%2Fapi.github.com%2Fgists%2F93976e340b0fa3ece1d0e443c64f35be#3.43/33.51/-101.81"></iframe>

## Getting used to YAML

Tangram is written in a syntax called [YAML](), which tends to be a little more friendly and easy to write in than [JSON](). YAML is reliant on indentations (any number of spaces or tabs is allowed, consistency is what's important). In a Tangram scene, there are a few required _blocks_ that define what is on the map.

**(maybe more on YAML?)**

The three things needed to build a web map in Tangram are:
- A defined data source (we'll be using [Mapzen vector tiles](https://mapzen.com/documentation/vector-tiles/), but you can add any [custom spatial data source]())
- Filtering rules describing which layers of the data source are going to be displayed
- Styling rules that describe what the layers should look like

The first requirement, defining the data source, is defined using the `sources` block in Tangram. The block is defined as `sources`, then the data source is given a name (`mapzen` in this example), and then we define the data type and url source.

```yaml
sources:
    mapzen:
        type: TopoJSON
        url: https://tile.mapzen.com/mapzen/vector/v1/all/{z}/{x}/{y}.topojson
```

Declaring a source is the first step in creating a Tangram map. In order to start seeing a map in the preview panes, we need to add filtering or styling rules. Let's do that!

## Style features in Tangram

To have features appear on the map, use the `layers` block to create a new layer, define the data to use and how it should be styled. To design the first basic layers of the map, water and land, two new layers have to be created. Create a `layer` block and name `_landLayer` (In this tutorial, layer names start with an underscore). The next step is to define the data source to use and what specific layer from the data to style. The data source declared in the previous step is named `mapzen`, so the source should also match that in the `data` block. To choose which layer we want to use, look at the [vector tiles documentation](https://mapzen.com/documentation/vector-tiles/layers/) to select the correct layer, in this case `earth` is the layer to style land.

The data we want to use has been selected, but won't appear in the editor until the `draw` block is written. The draw block .... (some info on it here)

There are specific draw styles for drawing features as points, lines, polygons, or text. The `_landLayer` can use the [`polygons` draw style](). To use this draw style, a color has to be provided (Tangram accepts RGB, RGBA, HEX, HSL) and an order. The drawing order is a _required_ element in Tangram, and defines the sequence for the map to render layers. This will be the bottom layer and should be defined as '0'. [More information on ordering here.](https://mapzen.com/documentation/vector-tiles/layers/#feature-ordering) With this draw block complete, a map should appear!

```yaml
layers:
    _landLayer:
        data:
          source: mapzen
          layer: earth
        draw:
            polygons:
                order: 0
                color: [0.443, 0.439, 0.431, 1.00]
```

To add water, make another called `_waterLayer ` that uses the `water` layer from the vector tiles source. This layer should also be drawn as a polygon and will follow the same format as the `_landLayer`, except order and color should be changed to reflect that this layer represents water. Water should be drawn on top of the land layer for features like lakes and rivers that would otherwise be cut off if underneath.

```yaml
_waterLayer:
       data:
           source: mapzen
           layer: water
       draw:
           polygons:
               order: 1
               color: [0.322, 0.396, 0.416, 0.32]
```

Here's what your map should look like:

<iframe class="demo-wrapper" src="https://mapzen.com/tangram/play/?scene=https%3A%2F%2Fapi.github.com%2Fgists%2F736784cbfee8b5a482c9af944d7b0363#3.00/31.81/-27.80"></iframe>


### Filtering boundary types

So far, this map shows basic land and water layers using the polygon draw style. The next layer to add takes advantage of another draw style, [lines](), to show administrative boundaries (a useful addition to most maps). To use the line draw style, there must be a specified color and width, along with the required order.

This layer with the layer name and the data being declared, this time the layer is changed to `boundaries`. The [boundaries](https://mapzen.com/documentation/vector-tiles/layers/#boundaries) layer documentation from Mapzen Vector Tiles mentions the various types of boundaries in this layer that should be styled differently to avoid confusion. On the same indent level as the `data` element, create another layer named `_countryBorders`.

The boundaries layer has properties that can be used to filter by administrative type, `kind_detail` in this instance. To filter just the country borders for this sublayer, set the `kind_detail = "2"` in a filter statement, enclosed by curly brackets (this is used for inline filtering). After the filter, a `draw` block can be used with the `lines` draw style. Add the draw order and then the desired color and width for the country border. There are [options for styling line features]() that can also be added, if desired.

While showing country borders is great at low zooms, adding additional boundaries for states and provinces adds detail as the zoom level increases. To add this additional sublayer, we create another layer named `_stateBorders` on the same indent level as `_countryBorders`. This layer will follow the same filter and draw rules as the previous layer, with some changes. The `kind_detail` for the boundaries layer should be set to "4" in the filter block. The draw style can be written the same as `_countryBorders`, except with a smaller sized width to show the different administrative levels of the two layers.

```yaml
_boundariesLayer:
       data:
           source: mapzen
           layer: boundaries
       _countryBorders:
           filter: { kind_detail: "2"  }
           draw:
               lines:
                   order: 2
                   color: [0.965, 0.953, 0.953, 1.00]
                   width: 1.75px
       _stateBorders:
           filter: { kind_detail: "4" }
           draw:
               lines:
                   order: 2
                   color: [0.745, 0.722, 0.714, 1.00]
                   width: 1px
```

After these boundaries layer, the map is shaping up to be a nice reference map at low zooms:

<iframe class="demo-wrapper" src="https://mapzen.com/tangram/play/?scene=https%3A%2F%2Fapi.github.com%2Fgists%2F5dff3ef94e95f1600893cc3c61930795#4.00/30.95/-72.49"></iframe>

### Styling at high zoom levels

Now that the low zoom levels have some basic detail, we should add some details that get added in at higher zooms like roads and buildings. Time to create two additional layers for this map, `_roadsLayer` and `_buildingsLayer`, following on previous draw styles of lines and polygons. You can further filter the roads and building layers as desired, as taught in the previous section.

#### Roads layer

The `roads` layer in Mapzen vector tiles starts at zoom 5 with highways and increases detail with higher zoom levels. These features should be styled as lines. Set the data `layer` to 'roads' and create a draw style that uses the `lines` style and add the desired color and width, with the order set to be be 3, the top layer so far. With increasing zoom levels and added detail, it makes sense to increase the widths of roads with zoom level. Unlike in previous uses of the line style where a constant value was used for width, [stops]() can be used to dynamically change the road layer's width at varying zoom levels.

Stops are 2-dimensional arrays that can replace a constant value in Tangram, to add a subtle transition to a feature and make sure features have the correct prominence at every zoom level. Stops always follow the format of [[zoom, value],[zoom2, value2]] with as many items in the array as desired. The default unit of the value is always `meters`. In between the zoom levels, the values are interpolated linearly for stops using width. Outside of the range specified by the stops, the values are capped by the highest and lowest values in the range.

For this roads layer, the first pair will be `[5,1px]` which means that at zoom 5 the road's width will be 1 pixel. Add in 3 additional stops to see how they work with the roads layer. The code bank below shows an example set of stops that will increase the width slightly.

```yaml
_roadsLayer:
        data:
            source: mapzen
            layer: roads
        draw:
            lines:
                order: 3
                color: [0.667, 0.643, 0.627, 1.00]
                width: [[5,1px],[8,1.5px],[11,2px],[15,2.5px]]
```

#### Buildings Layer

While roads are a very useful feature to have displayed at high zoom levels on a map, adding building footprints can make a map at high zooms appear more realistic. Create a new layer called `_buildingsLayer` that uses the `buildings` layer from the vector tiles source. These can be drawn in a polygon draw style with a set color and an order of 4 to add to the top layer.

```yaml
_buildingsLayer:
        data:
            source: mapzen
            layer: buildings
        draw:
            polygons:
                order: 4
                color: [0.290, 0.278, 0.278, 1.00]
```

By adding the roads and building layers, you should have a map that transitions from low to high zooms with added detail. Here's what the map should look like now:

<iframe class="demo-wrapper" src="https://mapzen.com/tangram/play/?scene=https%3A%2F%2Fapi.github.com%2Fgists%2F671f61101f2d570b80d1893dcfc49761#16.00/40.73009/-73.98415"></iframe>


### Label that map!

At this point, the map should have details added from low to high zoom levels with almost everything needed on a map, except for one important feature: labels. The last layer on the map will be called `_countryName` and use the text layer included in the vector tiles source called [places](). This layer in the tiles has the labels for administrative features like countries, regions, cities and more. Based on the layer's name, a filter needs to be added to only show country names.

Once the the new layer has created with the `places` layer specified, the filter function should be added. This follows the same formula as the boundaries filter used earlier. The filter should specify country labels only, so use `kind: country`.

The `places` layer also has population included in the data properties. This can be used to further filter this layer, adding different styling rules for different sized features. Add a comma after the first rule and create another filter for populations where the minimum is 30 million. This statement should be in curly brackets as it has an additional filter, with the correct filter as `population: { min: 30000000 }`.

Now that the filter rule has been created, it's time to use the draw block and a new type of draw style: [text](). Like `lines` and `polygons` the text draw style has required elements besides order. Inside the `text` draw style, the `font` element has to be declared with at least one [font parameter]() in it. To make the country labels stand out, add a `fill` that contrasts against the dark map. Set the order to be drawn on top and the `_countryName` layer is done.

```yaml
_countryName:
       data:
           source: mapzen
           layer: places
       filter: { kind: country, population: { min: 30000000 } }
       draw:
           text:
               font:
                   fill: [0.788, 0.694, 0.380, 1.00]
               order: 5
```

With this layer being finished, the map is finally complete! You should have a map that has administrative borders, country labels, roads, and buildings.

<iframe class="demo-wrapper" src="https://mapzen.com/tangram/play/?scene=https%3A%2F%2Fapi.github.com%2Fgists%2F7b9c01258e0a96c0f7171bd0e5060e5d#3.38/37.35/-85.26"></iframe>

###Summary and next steps

You just created your first map with Tangram! Build on what you have learned here to make the exact map you want. Take a look at the [vector tiles]() documentation to see what other layers can be added or add more customization to your map through style parameters in [Tangram](). Learn how to [publish your Tangram map]() and share your map on the web or add more complexity to this map with more [tutorials]().
