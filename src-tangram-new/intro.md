# Make a map in Tangram

[Tangram](index.md) is a 2D and 3D map renderer that allows you to make web maps with infinite possibilities. Tangram is built off of [WebGL](index.md#webgl) and uses a syntax style called [YAML](index.md#YAML) to control the map design with extremely fine detail, if desired. This step-by-step tutorial will walk you through making your first Tangram map.  

This tutorial uses [Tangram Play](), an in-browser text editor for Tangram. You can also build Tangram maps in a [text editor running a Python web server]().

To complete this tutorial, you need a [browser that supports WebGL](https://get.webgl.org/). You will need to maintain an Internet connection while you are working so you can access the map source data, which is being streamed from Mapzen's servers. It should take you about an hour to complete the exercise and you'll create a map that looks like this:

<iframe class="demo-wrapper" src="https://mapzen.com/tangram/play/embed/?scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom1.yaml#16.50417/40.78070/-73.96085"></iframe>

## Getting used to YAML

Tangram is written in a syntax called [YAML](), which tends to be a little more friendly and easy to write in than [JSON](). YAML is reliant on indentations (any number of spaces or tabs is allowed, consistency is what's important)
