# Editing Map views in Tangram

## lights
*This is the technical documentation for Tangram’s lights. For a conceptual overview of the lighting system, see the [Lights Overview](Lights-Overview.md).*

#### `Lights`

The `lights` element is a top-level element in the [scene file](Scene-file.md). Individual lights are defined by a *light name* under this element.

```yaml
lights:
    mainlight:
        type: directional
```

Note: To have your map colors match your style colors exactly in all cases, do not specify any lights. In this case, the **default light** will be a _directional light_ whose _diffuse_ and _ambient_ components have been tuned to exactly produce 100% illumination, while providing some shading on 3D-extruded features. In this way, 3D buildings will have shading, while the colors of all other flat features will precisely match their `color` declarations.

#### Light names
Required _string_. Can be anything*. No default.

```yaml
lights:
    light1:
        type: ambient
    directionalLight:
        type: directional
    point-light:
        type: point
```
* For technical reasons, hyphens in light names are converted to underscores internally. Thus "light-1" becomes "light_1". For this reason, you may not have two lights whose names are identical except for a hyphen in one case and an underscore in the same place in the other (eg "light-1" and "light_1"a) as they will be interpreted as the same name.

## Common light parameters

#### `type`

Required _string_. One of `ambient`, `directional`, `point`, or `spotlight`. No default.

```yaml
lights:
    light1:
        type: ambient
    light2:
        type: directional
    light3:
        type: point
    light4:
        type: spotlight
```

#### `ambient`

Optional parameter. _number_, `[R, G, B]`, _hex-color_, or _css color name_. Numerical values go from `0` to `1`. Defaults to `0`.

```yaml
    light1:
        type: point
        diffuse: white
        ambient: .3
```

#### `diffuse`

Optional parameter. _number_, `[R, G, B]`, _hex-color_, or _css color name_. Numerical values go from `0` to `1`. Defaults to `1`.

```yaml
light1:
    type: point
    diffuse: white
```

#### `specular`

Optional parameter. _number_, `[R, G, B]`, _hex-color_, or _css color name_. Numerical values go from `0` to `1`. Default is `0`.

```yaml
light1:
    type: directional
    direction: [0, 1, -.5]
    diffuse: white
    specular: ‘#FFFF99’
```

#### `visible`

Optional _Boolean_. Default is `true`.

Allows a defined light to be disabled or enabled through the JavaScript API.

```yaml
light1:
    type: point
    visible: false
```

## Directional light properties

#### `direction`

Optional _vector_. `[x, y, z]`. Defaults to `[0.2, 0.7, -0.5]`

```yaml
light1:
    type: directional
    direction: [0, 1, -.5]
```

## Point light properties

#### `position`

Required _vector_ `[x, y, z]`, _[lat, long]_, or _{ lat: number, lng: number }_. Vectors may be specified in meters `m` or pixels `px`, depending on the value of `origin`. _[lat, long]s_ may be specified as _lists_ or _objects_ of the format _{ lat: number, lng: number}_. Default is `[0, 0, 100px]`. Default unit for vectors are `m`.

```yaml
lights:
    cameralight:
        type: point
        position: [0px, 0px, -700px]
        origin: camera

    worldlight-ground:
        type: point
        position: [ 0m, 100m, 500m ]
        origin: ground

    worldlight-world:
        type: point
        position: [-74.00976419448853, 40.70531887544228, 500m]
        origin: world

```

#### `origin`

Optional _string_, one of `world`, `camera`, or `ground`. Defaults to `ground`.

Sets the reference point for the `position` parameter:

- `world`: sets x and y in _[lat, lng]_ and z in `m` from the ground
- `camera`: sets x and y in `px` from the camera center, and z in `m` from the camera
- `ground`: sets x and y in `px` from the point on the ground in the center of the current view, and z in `m` from the ground

```yaml
light1:
    type: point
    position: [0px, 0px, 300px]
    origin: ground
```

#### `radius`

Optional _number_ or `[inner_radius, outer_radius]`. Assumes units of meters `m`. Defaults to `null`.

If only a single _number_ is set, it defines the outer radius, and the inner radius is set to `0`.

```yaml
light1:
    type: point
    diffuse: white
    radius: [300,700]
```

#### `attenuation`

Optional _number_. Defaults to `1`.

Sets the exponent of the attenuation function, which is applied between the inner and outer `radius` values.

```yaml
light1:
    type: point
    radius: [300,700]
    attenuation: 0.2
```

## Spotlight properties

#### `direction`

This is the same as the _[directional light](#directional-light-properties)_'s [direction](lights,md#direction) property.

#### `position`

This is the same as the _[point light](#point-light-properties)_'s [position](lights.md#position) property.

#### `origin`

This is the same as the _[point light](#point-light-properties)_'s [origin](lights.md#origin) property.

#### `radius`

This is the same as the _[point light](#point-light-properties)_'s [radius](lights.md#radius) property.

#### `attenuation`

This is the same as the _[point light](#point-light-properties)_'s [attenuation](lights.md#attenuation) property.

#### `angle`

Optional _number_, in degrees. Defaults to `20`.

Sets the width of the spotlight's beam.

```yaml
light1:
    type: spotlight
    direction: [0, 1, -.5]
    position: [0, 0, 300]
    origin: ground
    radius: 700
    angle: 45
```

#### `exponent`

Optional _number_. Defaults to `0.2`.

This parameter sets the exponent of the spotlight's fallof, from the center of the beam to the edges. Higher values will give a sharper spotlight.

```yaml
light1:
    type: spotlight
    direction: [0, 1, -.5]
    position: [0, 0, 300]
    origin: ground
    diffuse: white
    ambient: .3
    radius: 700
    attenuation: 0.2
    angle: 45
    exponent: 10.
```

## cameras
*This is the technical documentation for Tangram's cameras. For a conceptual overview of the camera system, see the [Cameras Overview](Cameras-Overview.md).*

####`cameras`

The `cameras` element is an optional top-level element in the [scene file](Scene-file.md). Individual cameras are defined by a *camera name* under this element.
```yaml
cameras:
    camera1:
        type: perspective
    camera2:
        type: perspective
    overview:
        type: isometric
```

#####`camera`
It is also permissable to use the element name `camera` at the top level, if there is only a single camera in the scene:

```yaml
camera:
    type: perspective
```

#### camera names
Required _string_ (except in the case of [`camera`](cameras.md#camera)). Can be anything except the [reserved keywords](yaml.md#reserved-keywords). No default.

```yaml
cameras:
    myCamera:
        type: perspective
    camera2:
        type: perspective
    lock-off:
        type: perspective
```
## common camera parameters

####`type`
Required _string_. One of `perspective`, `isometric`, or `flat`. No default.
```yaml
cameras:
    camera1:
        type: perspective
    camera2:
        type: isometric
    overview:
        type: flat
```

####`position`
Optional _[lat, lng]_ or _[lat, lng, zoom]_. No default.

Sets the longitude and latitude of the camera, in degrees.
```yaml
camera1:
    position: [-73.97297501564027, 40.76434821445407]
```

####`zoom`
Optional _number_. Default: `15`

Sets the zoom level of the view, in standard [Web Mercator](http://en.wikipedia.org/wiki/Web_Mercator) zoom levels.

```yaml
camera1:
    zoom: 14
```

####`active`
Optional _boolean_. `true` or `false`. No default.

Sets the camera which provides the active view of the map when it is first loaded. If multiple cameras are defined, only one may be active at a time. If multiple cameras are set as `active: true`, the behavior will be unpredictable (see the [yaml#mappings](yaml.md#mappings) entry). The [JavaScript API](Javascript-API.md) can be used to [get](Javascript-API.md#getactivecamera) or [set](Javascript-API.md#setactivecamera_string_-camera) the active camera.

```yaml
camera1:
    active: false
```

####`max_tilt`
[ES-only] Optional _number_ or _[stops](yaml.md#stops)_. Degrees. Defaults to `90`.

Sets the maximum angle from vertical that the camera is permitted to tilt. For cameras with `type: isometric` the tilt is further constrained at high zooms to prevent the viewing plane from intersecting the ground.

##perspective camera parameters

####`focal_length`
Optional _number_ or _[stops](yaml.md#stops)_. Unitless. Defaults to `[[16, 2], [17, 2.5], [18, 3], [19, 4], [20, 6]]`.

Sets the amount of vertical exaggeration in the z-plane. Changes the apparent height of extruded elements. Lower values = more exaggeration. Also see `fov`.

```yaml
camera1:
    focal_length: [[16, 2], [17, 2.5], [18, 3], [19, 4], [20, 6]]
```
####`vanishing_point`
Optional _[number, number]_, in `px`. Defaults to `[0px, 0px]`. Units default to `px`.

Sets the apparent perspective origin, in pixels from the center of the screen.

```yaml
camera1:
    type: perspective
    vanishing_point: [-250, -250]
```

####`fov`
Optional _number_.

Sets the "field of view" of the camera, in degrees. Field of view has an inverse relationship with `focal_length`: higher values cause more exaggeration. If both are set, `focal_length` will take precedence over `fov`.

```yaml
camera1:
    fov: 80
```

##isometric camera parameters

####`axis`
Optional _[number, number]_. Default: `[0, 1]`

Sets the `[x, y]` direction and amount of the isometric camera's vertical axis, which controls controls how extruded objects' height is displayed. A value of `1` equals a scale of 100%. Larger values produce more scaling.

```yaml
isometric-cam:
    type: isometric
    axis: [1, .5]
```

##flat camera parameters

The `flat` camera presents a top-down 2D map view (extrusion is not visible), and has no unique parameters.
