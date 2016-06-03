# Get started with Mapzen

## API key

Mapzen provides geocoding, routing, and mapping tools that you can access through a hosted web service. To use the services, you need an API Key, which a code that uniquely identifies the your developer account without providing a password.

Mapzen uses authentication through GitHub.com, which is a website that enables people to collaborate on a project.

1. If you do not have a GitHub account, create one at https://github.com/join. It can be any kind, including personal.
2. Go to https://mapzen.com/developers. This is where you can create, delete, and manage your API keys.
3. Sign in with your GitHub account. If you have not done this before, you need to agree to the terms first.
4. Create a new key for the product you want to use.
5. Optionally, give the key a name so you can remember the purpose of the project.
6. When you are ready to use it, copy the key and paste it into your code.

Mapzen's web services have various API endpoints that allow you to access web resources through a URL. You will need to include your API key in the URL you construct to send queries to Mapzen's services.   

## Rate limits
The free tier of Mapzen's services is a shared resource, so there are limitations to prevent individual users from degrading system performance for everyone.

The services have maximum numbers of queries you can make per second and per day, and some have additional limitations on computationally intensive uses.

All these projects are open source. If you need higher capacity or customizations, you can install the code on your own servers.

### Mapzen Search

Mapzen Search is a geocoding and place-finding service and has these limits:

- 6 queries per second
- 30,000 queries per day

### Mapzen Turn-by-Turn

Mapzen Turn-by-Turn is a routing and navigation service and has these limits:

- 2 queries per second
- 50,000 queries per day
- Pedestrian routes have a limit of 50 locations and 250 kilometers.
- Bicycle routes have a limit of 50 locations and 500 kilometers.
- Automobile routes have a limit of 20 locations and 5,000 kilometers.

The distance limit is the total straight-line distance (colloquially "as the crow flies") along a path through successive locations.

### Mapzen Matrix

Mapzen Matrix service provides time and distance calculations between locations and has these limits.

- 2 queries per second
- 5,000 queries per day
- The maximum number of locations is 50 for any type of matrix.
- The maximum straight-line distance between two locations is 200,000 meters (200 km). For one-to-many, the distance between the first location and any of the others cannot exceed the maximum. For many-to-one, the distance between the last location and any of the others cannot exceed the maximum. Finally, for many-to-many, the distance between any pair of locations cannot exceed the maximum.

### Mapzen Elevation

Mapzen Elevation provides the height or elevation at a set of locations and has these limits:

- 2 queries per second
- 20,000 queries per day

There are also limitations on the number of sampling points. The limits are related to the number of points for which you request elevations, rather than the resolution of the digital elevation model in that area.

### Mapzen Vector Tiles

Vector Tiles provides global basemap coverage and has no limits.

You can cache the tiles for offline use, but cannot bundle the tiles for purposes of reselling them.

### Other products

Mapzen's other software and data projects do not need API keys. These include:

- Tangram, the rendering engine for web and mobile apps
- Data products, such as Who's on First and Metro Extracts (downloadable snapshots of OpenStreetMap data)
- Transitland, the open transit data project.

## Terms of use

Mapzen's services are available for any use, including commercial purposes. You need to follow the attribution requirements for the data source, and also provide acknowledgement to Mapzen if you are using the web services.
