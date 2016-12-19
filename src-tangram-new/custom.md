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
    if (typeof iframe != "undefined") {
        try {
            if (typeof iframe.contentWindow.scene != 'undefined') {
                // make a new blob from the codemirror code

                // var blob = new Blob([JSON.stringify(iframe.contentWindow.editor.getValue(), null, 2)], {type: "text/plain"});
                var blob = new Blob([iframe.contentWindow.editor.getValue()], {type: "text/plain"});
                // make an objectURL from the blob and save that to the parent div
                el.setAttribute("code", window.URL.createObjectURL(blob));
                console.log('saved', el.getAttribute("code"))
                el.removeChild(iframe);
            }
        }
        catch(e) {
            console.log(e);
            el.removeChild(iframe);
        }
    }
}
function show(el) {
    if (typeof el != 'undefined') {
        iframe = el.getElementsByTagName("iframe")[0];
        if (typeof iframe == "undefined") {
            iframe = document.createElement("iframe");
            var source = '';
            el.appendChild(iframe);
            iframe.style.height = "100%";
            if (typeof el.getAttribute("source") != 'undefined') {
                // get the source
                source = el.getAttribute("source");

            }

            if (el.getAttribute("code") !='' && el.getAttribute("code") !='null') {
                // get source from the previously-saved blobURL
                var code = el.getAttribute("code");
                iframe.src = replaceUrlParam(el.getAttribute("source"), "scene", code);
                // el.setAttribute("code", '')
                // window.URL.revokeObjectURL(url);

            } else {
                iframe.src = el.getAttribute("source");
            }
        }
    }
}

function replaceUrlParam(url, paramName, paramValue){
    // from http://stackoverflow.com/questions/7171099/how-to-replace-url-parameter-with-javascript-jquery
    if(paramValue == null)
        paramValue = '';
    var pattern = new RegExp('\\b('+paramName+'=).*?(&|$)')
    if(url.search(pattern)>=0){
        return url.replace(pattern,'$1' + paramValue + '$2');
    }
    return url + (url.indexOf('?')>0 ? '&' : '?') + paramName + '=' + paramValue 
}


// check visibility every half-second, hide off-screen demos to go easy on the GPU
setInterval( function() {
    var elements = document.getElementsByClassName("demo-wrapper");
    for (var i=0; i < elements.length; i++) {
        el = elements[i];
        if (elementIntersectsViewport(el) || (i == 0 && window.pageYOffset < 500)) {
            show(el);
            // show the next two iframes as well
            // show(elements[i+1]);
            // show(elements[i+2]);
            for (var j=0; j < elements.length; j++) {
                // if (j != i && j != i+1 && j != i+2) {
                if (j != i) {
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

Tangram draws map features using its built-in styles: `polygons`, `lines`, `points`, `text`, and `raster`. Using the `styles` element, you can customize the behavior of these draw styles, either by using the many built-in customization features, or by making your own effects from scratch using [shaders](shaders.md).

## Dashed lines with built-in `dash` options

Let's use one of the built-in style customization options, [`dash`](styles.md#dash), to draw some dashed lines. Add a datasource to your map with a [`source`](source.md) entry, then add some lines to your map - let's start with road features.

<!-- <div class="demo-wrapper" id="demo0" code="" source="https://precog.mapzen.com/tangrams/tangram-play/36695453b02953bf94ca3fd37d255a9f047f7032/embed/?go=👌&scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom6.yaml#16.50417/40.78070/-73.96085"></div> -->
<div class="demo-wrapper" id="demo0" code="" source="https://precog.mapzen.com/tangrams/tangram-play/master/embed/?go=👌&scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom6.yaml#16.50417/40.78070/-73.96085"></div>

Note: in the examples in this tutorial, we are relying on a couple of similar shortcuts to set our _data layers_ and _draw styles_. Rather than give a custom name to each layer and set its data layer separately, like so:

```yaml
layers:
    _my_roads:
        data: { source: mapzen, layer: roads }
```

We're omitting the `layer` declaration, and simply naming our layer the name of the data layer we wish to draw:

```
layers:
    roads:
        data: { source: mapzen }
```

Similarly, rather than giving a custom name to each _draw group_ and specify its _draw style_ explicitly, like so:

```yaml
layers:
    roads:
        data: { source: mapzen }
        draw:
            _my_lines:
                style: lines
                width: 2px
```

We're omitting the `style` declaration, and simply naming our _draw group_ the name of the _draw style_ we wish to use:

```
layers:
    roads:
        data: { source: mapzen }
        draw:
            lines:
                width: 2px
```

Now let's make a custom _draw style_, let's call it '_dashes' – the underscore is a handy way to remember which things we named ourselves. The `dash` parameter takes an array, which sets the length of the dashes and gaps.

<div class="demo-wrapper" id="demo1" code="" source="https://mapzen.com/tangram/play/embed/?go=👌&scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom7.yaml#16.50417/40.78070/-73.96085"></div>


Note: in the examples in this tutorial, we are relying on a couple of similar shortcuts to set our _data layers_ and _draw styles_. Rather than give a custom name to each layer and set its data layer separately, like so:

```yaml
layers:
    _my_roads:
        data: { source: mapzen, layer: roads }
```

We're omitting the `layer` declaration, and simply naming our layer the name of the data layer we wish to draw:

```
layers:
    roads:
        data: { source: mapzen }
```

Similarly, rather than giving a custom name to each _draw group_ and specify its _draw style_ explicitly, like so:

```yaml
layers:
    roads:
        data: { source: mapzen }
        draw:
            _my_lines:
                style: lines
                width: 2px
```

We're omitting the `style` declaration, and simply naming our _draw group_ the name of the _draw style_ we wish to use:

```
layers:
    roads:
        data: { source: mapzen }
        draw:
            lines:
                width: 2px
```

Now let's make a custom _draw style_, let's call it '_dashes' – the underscore is a handy way to remember which things we named ourselves. The `dash` parameter takes an array, which sets the length of the dashes and gaps.

<div class="demo-wrapper" id="demo2" code="" source="https://mapzen.com/tangram/play/?go=👌&scene=https://tangrams.github.io/tangram-docs/tutorials/custom/custom8.yaml#16.50417/40.78070/-73.96085"></div>

