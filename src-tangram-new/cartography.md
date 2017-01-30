# Designing a basemap in Tangram

The [introductory tutorial](intro-tutorial.md) goes over the basics of making a web map using [Tangram](index.md). In this follow up tutorial, you will be able to make a complete base map with common features that cartographers use in map design, such as:

- adding custom fonts and icons for label layers
- creating dashed lines for disputed boundaries
- using outlines for highway roads
- styling landuse layers

This tutorial uses [Tangram Play](https://mapzen.com/tangram/play), an in-browser text editor for Tangram. You can also build Tangram maps in a [text editor running a Python web server]().

To complete this tutorial, you need a [browser that supports WebGL](https://get.webgl.org/). You will need to maintain an Internet connection while you are working so you can access the map source data, which is being streamed from Mapzen's servers. It should take you several hours to complete the exercise and you'll create a map that looks like this:

<iframe class="demo-wrapper" src="https://mapzen.com/tangram/play/?lines=213-217%2C219-221%2C223-228&scene=https%3A%2F%2Fapi.github.com%2Fgists%2F26856950d07333cafe2fa9212ef1d7cf#5.073/40.400/-98.746"></iframe>

## Adding custom fonts and textures

While Tangram offers several [web fonts]() included in the renderer, you can also add your own preferred typefaces using the `fonts` block. Tangram supports any common font format, including OTF, TTF, and WOFF. To import a font, create a block named `fonts` and add a layer underneath for the typeface you're importing to create a [font face definition](). In this case, [Lora](https://fonts.google.com/specimen/Lora) from Google Fonts. Name the layer `Lora` for the typeface style and add a URL to load the font. You might want to add multiple weights or styles of a font for different layers. This tutorial will need a medium weight version of Lora and an italic version, so to specify the different options you can add the . You can also add fonts through an [external CSS stylesheet, or store them in a folder]().

```yaml
fonts:
    Lora:
        - style: normal
          url: https://fonts.gstatic.com/s/lora/v9/mlTYdpdDwCepOR2s5kS2CwLUuEpTyoUstqEm5AMlJo4.woff2
        - style: italic
           url: https://fonts.gstatic.com/s/lora/v9/_IxjUs2lbQSu0MyFEAfa7ZBw1xU1rKptJj_0jans920.woff2
```

A common way to label a point feature like a city or point of interest is with an icon/sprite as a point with a label next to it. While there are several ways to [import icons]() in a Tangram scene, in this tutorial you will import the point icons using a [textures]() block. Just like the font block, name the layer and add the URL one indent level below. There are often different types of point icons used to distinct capitals from cities. Use the two URLs below to create two separate textures with the icons linked.

```yaml
textures:
    city:
        url: https://raw.githubusercontent.com/tangrams/cartography-docs/master/img/sprite/bubble-wrap-style/2x/townspot-s-rev.png
    capital:
        url: https://raw.githubusercontent.com/tangrams/cartography-docs/master/img/sprite/bubble-wrap-style/2x/capital-m.png
```

<<<<<<< HEAD
## Styling basic layers

The first layers that are required for a base map are the essential water and earth layers to distinguish water and land from each other. In the [previous tutorial](intro-tutorial.md), the `earth` layer was styled as a `polygon` draw style; this time to color what's land on the map, you'll use a background color. This can improve performance of the map as well as fill in any data gaps between the `land` and `water` layers. The `earth` layer will still be used to draw the labels for continents.

To create a background color, use the `scene` block and create a [background]() block with a color in it.

```yaml
scene:
    background:
        color: [1.000,0.923,0.844,1.0]
```

### Adding continent layers

To label the continents, draw a `text` style from the `earth` layer where `kind: continent` and the max zoom is set to 5. Create a `font` element inside of the `text` block. To set the text size, there could be one given number or take advantage of a neat feature in Tangram: [stops](). Stops are an array of values to change at zoom levels. Each 'stop' needs to have two parts: the zoom level in the first part and the value to change, for instance: [1,18px] where 1 is the zoom level and the font size is set at 18px. Stops can be used for any `color` or `width` property, where you might want the color to change on an increased zoom, or have labels decrease in size for decreased prominence in increasing zoom. For a feature like continent labels that's intended for zooms 1 - 5, an increasing zoom will maintain its prominence in the foreground until it disappears. Make a series of stops with increasing font size for the `size` property.

For a continent label, you might also want to style it differently, setting it to be upper case using the [transform]() property and using the custom italic typeface by setting `style: italic`.

Below is a completed `_earthLabels` block:

```yaml
_earthLabels:
        data:
            source: mapzen
            layer: earth
        filter:
            all:
                - kind: [continent]
                - $zoom: { max: 5 }
        draw:
            text:
                font:
                    size: [[1,18px],[2,20px],[3,24px],[4,32px]]
                    fill: [0.776, 0.655, 0.565, 1.00]
                    transform: uppercase
                    style: italic
```

### Adding water layers

 Water features are going to use three style types- polygons for the fill, lines for additional detail, and a label sublayer. This 


```yaml
_waterLayer:
        data:
            source: mapzen
            layer: water
        filter:
            kind: [ocean, river, sea, lake]
        draw:
            polygons:
                order: 1
                color: [0.337, 0.463, 0.537, 0.89]
        _waterlines:
            filter:
                all:
                    - boundary: true
                    - kind: [ocean]
            draw:
                lines:
                    order: 2
                    color: [0.400,0.515,0.574,1.0]
                    width: 3px
                    join: round
                    cap: round
        _oceanLabel:
            filter: { kind: ocean }
            draw:
                text:
                    font:
                        family: Lora
                        size: [[1,12px],[3,24px],[7,36px]]
                        style: italic
                        fill: [0.308,0.396,0.441,1.0]
```

With the water and earth layers and labels added, the map should now look like this:

<iframe class="demo-wrapper" src="https://mapzen.com/tangram/play/?scene=https%3A%2F%2Fapi.github.com%2Fgists%2Ffa00e36073656a1c9ff5634bd7ef0ceb#3.31/10.08/94.72"></iframe>
=======
## Styling basic layers 
>>>>>>> parent of 25acbfd... tutorial writing
