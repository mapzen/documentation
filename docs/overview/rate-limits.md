# Rate limits

Mapzen offers some level of free access to each service, subject to rate limits. The services have maximum numbers of requests you can make per month, and some have additional service limitations to minimize computationally intensive uses.

To use Mapzen’s services above the free limits, you need to [add a payment method to your account](account-settings.md#add-your-payment-method) and enable billing.

All the projects used to build the Mapzen-hosted services are open source. If you want to try Mapzen’s products, start with the hosted services to see if they fit your workflow needs. If you later decide that you need additional customizations, you can consider installing on your own servers the open-source code used to build Mapzen’s services.

You must include an API key when using Mapzen’s services; requests sent without an API key return errors.

## Mapping products

### mapzen.js (Mapzen JavaScript SDK)

To use [mapzen.js](https://mapzen.com/documentation/mapzen-js/), the Mapzen JavaScript SDK, you need an API key. You are subject to the rate limits for the Mapzen service you are integrating in your app.

### Tangram

[Tangram](https://mapzen.com/documentation/tangram/), Mapzen's rendering software for web and mobile apps, does not require its own API key. However, if you are using Tangram to draw data from Mapzen's vector tiles service, you need an API key.

### Mapzen Basemap Styles

Mapzen's [cartography](https://mapzen.com/documentation/cartography/) requires an API key to enable access to Mapzen vector and terrain tiles data sources.

### Mapzen Vector Tiles

[Mapzen Vector Tiles](https://mapzen.com/documentation/vector-tiles/) provides global basemap coverage. The service has these limits:

- 50,000 free requests per month

When viewing a map, you commonly make about four requests at 512-pixel tile size, and about 15 requests at 256-pixel tile size.

The Mapzen Vector Tiles service is built from the [Tilezen](https://github.com/tilezen) open-source project.

### Mapzen Terrain Tiles

[Mapzen Terrain Tiles](https://mapzen.com/documentation/terrain-tiles/) provides global elevation coverage and there are no rate limits.

The Mapzen Terrain Tiles service is built from the [Joerd](https://github.com/tilezen/joerd) open-source project.

## Search and mobility products

### Mapzen Search

[Mapzen Search](https://mapzen.com/documentation/search/) is a geocoding and place-finding service. The service has these limits:

- 25,000 free requests per month for forward geocoding, reverse geocoding, and place lookup
- 50,000 free requests per month for autocomplete

The Mapzen Search service is built from the [Pelias](https://github.com/pelias) open-source project.

### Mapzen Turn-by-Turn

[Mapzen Turn-by-Turn](https://mapzen.com/documentation/turn-by-turn/) is a routing and navigation service. The service has these limits:

- 5,000 free requests per month
- Pedestrian routes have a limit of 50 locations and 250 kilometers.
- Bicycle routes have a limit of 50 locations and 500 kilometers.
- Automobile routes have a limit of 20 locations and 5,000 kilometers.
- Multimodal routes have a limit of 500 kilometers between locations.

The distance limit is the total straight-line distance (colloquially, as the crow flies) along a path through successive locations.

### Mapzen Matrix

[Mapzen Matrix](https://mapzen.com/documentation/matrix/) provides time and distance calculations between locations. The service has these limits:

- 1,000 free requests per month
- The maximum number of locations is 50 for any type of matrix.
- The maximum straight-line distance between two locations is 400 kilometers for automobiles and similar transportation modes, and 200 kilometers for other options.

### Mapzen Optimized Route

[Mapzen Optimized Route](https://mapzen.com/documentation/optimized/) finds the most efficient route between many locations. The service has these limits:

- 100 free requests per month
- The maximum number of locations is 50.
- The maximum straight-line distance between two locations is 200 kilometers.

### Mapzen Isochrone

[Mapzen Isochrone](https://mapzen.com/documentation/mobility/isochrone/api-reference/) provides a computation of areas that are reachable within specified time periods from a location or set of locations. The service has these limits:

- 100 free requests per month
- The maximum number of locations is one. For isochrones around multiple locations, you need to make multiple requests.
- The maximum time to compute isochrone contours from the location is 120 minutes.
- The maximum number of isochrone contours in a single request is four.

### Mapzen Map Matching

[Mapzen Map Matching](https://mapzen.com/documentation/mobility/map-matching/api-reference/) matches coordinates to known roads so you can turn a path into a route with narrative instructions and get the attribute values from that matched line. The service has these limits:

- 1,000 free requests per month
- The maximum input shape distance is 200 kilometers when using the `map_snap` shape match and 1,000 kilometers when using the `edge_walk` shape match.
- The maximum number of input shape points is 16,000.
- The maximum input GPS accuracy is 100 meters.
- The maximum upper bounds of the search radius is 100 meters.

The Mapzen Mobility services are built from the [Valhalla](https://github.com/valhalla) open-source project.

## Data products

### Mapzen Elevation

[Mapzen Elevation](https://mapzen.com/documentation/elevation/) provides the height or elevation at a set of locations. The service has these limits:

- 5,000 free requests per month

There are also limitations on the number of sampling points for which you request elevations.

The Mapzen Elevation lookup service is built from the [Joerd](https://github.com/tilezen/joerd) open-source project.

### Mapzen Places

[Mapzen Places](https://mapzen.com/documentation/places/) provides administrative boundaries and hierarchies, neighbourhoods, postal codes, venues, and more from the [Who's On First](https://whosonfirst.mapzen.com/) dataset. The service has these limits:

- 25,000 free requests per month

### Libpostal address parsing

[Libpostal API](https://mapzen.com/documentation/libpostal/) parses and normalizes street addresses. The service has these limits:

- 1,000 free requests per month

### Other data products

Mapzen's other data products do not currently require API keys. These include:

- [Metro Extracts](https://mapzen.com/data/metro-extracts/), downloadable snapshots of OpenStreetMap data (Note: you will need to sign in with a developer account to download custom extracts)
- [Transitland](https://transit.land/), the open transit data project

## Mobile products

To use Mapzen's [Android](https://mapzen.com/documentation/android/) or [iOS](https://mapzen.com/documentation/ios/) SDKs or any of Mapzen's other products in your mobile apps, you need an API key. You are subject to the rate limits for the Mapzen service you are integrating in your app.
