#Walkthrough: Make a map with Tangram

With the [Tangram map renderer](https://mapzen.com/projects/tangram), you quickly can make beautiful and useful 2D and 3D maps. With easy customizations, you can have fine control over almost every aspect of your map's appearance, including symbols, lighting, geometry, and feature labels, and see your changes immediately. Tangram is [open source](https://github.com/tangrams/tangram), and supports several vector data formats.

Follow this step-by-step walkthrough to make your first Tangram map. 

To complete this walkthrough, you need a [browser that supports WebGL](https://get.webgl.org/). You will need to maintain an Internet connection while you are working so you can access the map source data, which is being streamed from Mapzen's servers. It should take you about an hour to complete the exercises.

###View the Tangram example map

(open in Tangram play? OR have it embedded here?)

### The Tangram scene file

Tangram uses a human-readable format called `.yaml` to organize all the styling elements needed to draw a map. This file, known as a scene, specifies the source of the data, which layers from that source to display on the map, and rules about how to draw those layers, such as color and line thickness.

1. Open `scene.yaml` in a text editor and scroll through the elements.
2. Notice that the elements are arranged in a hierarchy, with the top level elements being `cameras`, `lights`, `sources`, and `layers`. Each of these has additional subelements underneath them. The [scene file documentation](Scene-file.md) has more information about the top-level elements in a scene file. (Some of the code has been omitted in the block below.)

	```
	cameras:
   		camera1:

	lights:
    	light1:

	sources:
    	osm:

	layers:
    	earth:
	```
This part of the walkthrough has given you an introduction to Tangram and the contents of the scene file.  Now, you will edit the scene file to change the map's lighting and symbols.

###Update the scene lighting

Lighting enables visual effects like making the map appear as if it is being illuminated by the sun, viewed after dark, or lit only by the beam of a flashlight. The appearance of light is also affected by the materials it shines on, but setting properties of materials is beyond the scope of this walkthrough.

Currently, the map has a light source defined as `directional`, which you can think of as being sunlight. In these steps, you will add a new `light` element that resembles a flashlight shining from above. Darkening a scene by dimming the lighting parameters is a quick way to simulate night conditions, but you may need to modify the symbol colors if you are truly designing a map for viewing at night.

1. In `scene.yaml`, under `lights:`, add a  new `light2:` element at the same level as `light1:`.

	```
	lights:
		light1:
			[...]
		light2:
	```
2. Define `light2` with the following parameters, being careful to indent the lines under `light2:` with a tab.

	```
	light2:
		visible: true
		type: point
		position: [-74.0170, 40.7031, 100]
		origin: world
		ambient: .3
		diffuse: 1
		specular: .2
	```
3. Save `scene.yaml` and refresh the map.

The `position` parameter defines a light originating at an x-,y- coordinate location and at a z-value in meters from the ground, giving the appearance of a light pointed at the tip of Manhattan. You can learn more about lights and their parameters from the [lights documentation](lights.md).

![simple-demo with new light](images/simple-demo-new-light.png)

The updated map looks washed out and the new spot light is barely visible, so you can adjust `light1` to make the map look better.

1. Under `light1:`, change the `diffuse:` parameter to `.1`.
2. Change `ambient:` to `.3`. Your `lights:` section should look like this:

	```
	lights:
    		light1:
        		type: directional
        		direction: [0, 1, -.5]
        		diffuse: .1
        		ambient: .3
    		light2:
        		visible: true
        		type: point
        		position: [-74.0170, 40.7031, 100]
        		origin: world
        		ambient: .3
        		diffuse: 1
        		specular: .2
	```
3. Save `scene.yaml` and refresh the map.

	![simple-demo with combined lights](images/simple-demo-mod-light.png)

In these steps, you blended lights to achieve different effects. However, if you want to turn off a light completely, you can set its `visible` property to `false.`

###Update the layers in the map

Tangram can render data from different vector tile formats, as well as from individual files, such as a GeoJSON. The simple-demo map uses [vector tiles](https://mapzen.com/projects/vector-tiles) that display OpenStreetMap data from Mapzen’s servers. You specify the URL to the data in the `sources:` block, which requires a type (a designation for the data format) and a URL to the server or file. You can find more examples in the [sources documentation](sources.md).

After you specify the source, you need to list the layers from that source that you want to draw on the map. Optionally, you can include filters based on attribute values within a layer, such as to draw only major roads, and styling information about how the features should be symbolized. To learn more about the available layers, see the [Mapzen vector tile service documentation](https://github.com/mapzen/vector-datasource/wiki/Mapzen-Vector-Tile-Service#layers).

You specify how the display the features in the layers in the `draw:` block. There, you can enter basic information about colors and symbol sizes, as well as use more complex drawing techniques. For example, you can define shading or animations, enter code blocks, or reference other `.yaml` files. You can also specify the drawing order of layers to put certain layers on top of others. For example, in `scene.yaml`, the earth polygon layer, which represents landmasses, has an order of 0, meaning it will be underneath all other layers. Layers with order values of greater numbers are drawn on top of those with smaller numbers.

1. In `scene.yaml`, review the items under `layers:` to see which layers and feature types (`kind:`) are displayed in the map, and review the `draw:` block under each layer.
2. Under `water:`, change the `color:` value to `'#003366'`. Be sure to enclose the value in single quotation marks. Your `water:` block should look like this.
```
[...]
water:
		data: { source: mapzen }
		draw:
				polygons:
						order: 2
						color: '#003366'
[...]
```
3. Save `scene.yaml` and refresh the browser to see the updates.

	![Water with a darker color](images/change-water-color.png)

If you want to continue experimenting with Tangram symbols, try changing the `draw` values of other layers. For more on available drawing parameters, see the [styles documentation](styles.md).

When you are done, close the terminal window to shutdown the server and close your browser.

##Put your Tangram map on the web

(how to use Tangram JS)

###Summary and next steps

You have explored the basics of mapping with Tangram and the structure of the scene file, and maybe even posted your map to the web.

Tangram enables many options for rendering features on maps. To see other maps built with Tangram, visit the [Tangram website](https://www.mapzen.com/projects/tangram) and get links to sample code. Build on what you have learned here to make the exact map you want.
