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

This tutorial uses [Tangram Play](), an in-browser text editor for Tangram. You can also build Tangram maps in a [text editor running a Python web server]().

To complete this tutorial, you need a [browser that supports WebGL](https://get.webgl.org/). You will need to maintain an Internet connection while you are working so you can access the map source data, which is being streamed from Mapzen's servers. It should take you about an hour to complete the exercise and you'll create a map that looks like this:

<iframe class="demo-wrapper" src="https://mapzen.com/tangram/play/?scene=https%3A%2F%2Fapi.github.com%2Fgists%2F93976e340b0fa3ece1d0e443c64f35be#3.43/33.51/-101.81"></iframe>

## Getting used to YAML

Tangram is written in a syntax called [YAML](), which tends to be a little more friendly and easy to write in than [JSON](). YAML is reliant on indentations (any number of spaces or tabs is allowed, consistency is what's important). In a Tangram scene, there are a few required _blocks_ that define what is on the map.

(maybe more on YAML?)

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

### Adding land and water

To have features appear on the map, use the `layers` block to create a new layer, define the data to use and how it should be styled. To design the first basic layers of the map, water and land, two new layers have to be created. Create a `layer` block and name `_landLayer` (In this tutorial, layer names start with an underscore). The next step is to define the data source to use and what specific layer from the data to style. The data source declared in the previous step is named `mapzen`, so the source should also match that in the `data` block. To choose which layer we want to use, look at the [vector tiles documentation](https://mapzen.com/documentation/vector-tiles/layers/) to select the correct layer, in this case `earth` is the layer to style land.

The data we want to use has been selected, but won't appear in the editor until the `draw` block is written. The draw block .... (some info on it here)

There are specific draw styles for drawing features as points, lines, polygons, or text. The `_landLayer` can use the `polygons` draw style. To use this draw style, a color has to be provided (Tangram accepts RGB, RGBA, HEX, HSL) and an order. The drawing order is a _required_ element in Tangram, and defines the sequence for the map to render layers. This will be the bottom layer and should be defined as '0'. [More information on ordering here.](https://mapzen.com/documentation/vector-tiles/layers/#feature-ordering) With this draw block complete, a map should appear!

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

To add water, make another called `_waterLayer ` that uses the `water` layer from the vector tiles source. This layer should also be drawn as a polygon and will follow the same format as the `_landLayer`.

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

<iframe class="demo-wrapper" src="https://mapzen.com/tangram/play/?scene=https%3A%2F%2Fapi.github.com%2Fgists%2F4a1bbb65a2616469d4946ea623db4324#3.43/33.51/-101.81"></iframe>


### Filtering boundary types

<iframe class="demo-wrapper" src="https://mapzen.com/tangram/play/?scene=https%3A%2F%2Fapi.github.com%2Fgists%2F048a7c4152405cd538f57083177eb054#4.674/42.009/-99.610"></iframe>



### Styling at high zoom levels

<iframe class="demo-wrapper" src="https://mapzen.com/tangram/play/?scene=https%3A%2F%2Fapi.github.com%2Fgists%2F03bc906e0ca2d5fe42750064ff0ae44d#15.2117/43.0724/-89.4038"></iframe>


### Label that map!
<iframe class="demo-wrapper" src="https://mapzen.com/tangram/play/?scene=https%3A%2F%2Fapi.github.com%2Fgists%2F1f900ad4209ba2aa4e2585b7876c74f0#3.30/31.79/-27.79"></iframe>

### Publishing the map
