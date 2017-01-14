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

## Styling basic layers 
