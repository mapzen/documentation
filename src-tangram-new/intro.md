# Make a map in Tangram

[Tangram](index.md) is a 2D and 3D map renderer that allows you to make web maps with infinite possibilities. Tangram is built off of [WebGL](index.md#webgl) and uses a syntax style called [YAML](index.md#YAML) to control the map design with extremely fine detail, if desired. This step-by-step tutorial will walk you through making your first Tangram map.  

This tutorial uses [Tangram Play](), an in-browser text editor for Tangram. You can also build Tangram maps in a [text editor running a Python web server]().

To complete this tutorial, you need a [browser that supports WebGL](https://get.webgl.org/). You will need to maintain an Internet connection while you are working so you can access the map source data, which is being streamed from Mapzen's servers. It should take you about an hour to complete the exercise and you'll create a map that looks like this:

<iframe class="demo-wrapper" src="https://mapzen.com/tangram/play/?scene=https%3A%2F%2Fapi.github.com%2Fgists%2F93976e340b0fa3ece1d0e443c64f35be#3.43/33.51/-101.81"></iframe>

## Getting used to YAML

Tangram is written in a syntax called [YAML](), which tends to be a little more friendly and easy to write in than [JSON](). YAML is reliant on indentations (any number of spaces or tabs is allowed, consistency is what's important). In a Tangram scene, there are a few required _blocks_ that define what is on the map.

The three things needed to build a web map in Tangram are:
- A defined data source (we'll be using [Mapzen vector tiles](https://mapzen.com/documentation/vector-tiles/), but you can add any [custom spatial data source]())
- Filtering rules describing which layers of the data source are going to be displayed
- Styling rules that describe what the layers should look like

The first requirement, defining the data source, is defined using the `sources` block in Tangram. The block is defined as `sources`, then the data source is given a name ('mapzen' in this example), and then we define the data type and url source.

```yaml
sources:
    mapzen:
        type: TopoJSON
        url: https://tile.mapzen.com/mapzen/vector/v1/all/{z}/{x}/{y}.topojson
```

While this is the most important of building a map in Tangram, nothing has changed in the preview pane because we haven't added any filtering or styling rules. Let's do that!

### Adding land and water


<iframe class="demo-wrapper" src="https://mapzen.com/tangram/play/?scene=https%3A%2F%2Fapi.github.com%2Fgists%2F4a1bbb65a2616469d4946ea623db4324#3.43/33.51/-101.81"></iframe>


### Filtering boundary types

<iframe class="demo-wrapper" src="https://mapzen.com/tangram/play/?scene=https%3A%2F%2Fapi.github.com%2Fgists%2F048a7c4152405cd538f57083177eb054#4.674/42.009/-99.610"></iframe>



### Styling at high zoom levels

<iframe class="demo-wrapper" src="https://mapzen.com/tangram/play/?scene=https%3A%2F%2Fapi.github.com%2Fgists%2F03bc906e0ca2d5fe42750064ff0ae44d#15.2117/43.0724/-89.4038"></iframe>


### Label that map!
<iframe class="demo-wrapper" src="https://mapzen.com/tangram/play/?scene=https%3A%2F%2Fapi.github.com%2Fgists%2F1f900ad4209ba2aa4e2585b7876c74f0#3.30/31.79/-27.79"></iframe>
