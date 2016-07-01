# Rate limits for Mapzen's products

Mapzen's products help you put a map anywhere, search and route the planet, and try a world of open data. These are built from open-source tools that are packaged into a web service and hosted on Mapzen's servers. If you want to use Mapzen's services, you need to create a Mapzen developer account and a valid API key, and keep your requests to the service within certain rate limits.

## Mapzen developer accounts and API keys

Mapzen developer account authentication is through [GitHub](https://github.com), which is a website that enables people to collaborate on a project. You need to have a GitHub account to create a Mapzen developer account, as there is currently no other form of authentication.

When signed in to your Mapzen developer account, you see a dashboard where you can create an API key, which is a code that uniquely identifies your developer account without providing a password.

1. If you do not have a GitHub account, create one at https://github.com/join. It can be any kind, including personal.
2. Go to https://mapzen.com/developers. This is where you can create, delete, and manage your API keys.
3. Sign in with your GitHub account. If you have not done this before, you need to agree to the terms first.
4. Create a new key for the Mapzen product you want to use.
5. Optionally, give the key a name so you can remember the purpose of the project.
6. When you are ready to use it, copy the key and paste it into your code.

Mapzen's web services have various API endpoints that allow you to access web resources through a URL. You will need to include your API key in the URL you construct to send queries to Mapzen's services.   

## Pricing and rate limits
Mapzen offers a free tier of each service, subject to the rate limits listed below. The free tier is a shared resource, so there are limitations to prevent individual users from degrading system performance for everyone.

The services have maximum numbers of queries you can make within a certain period of time, and some have additional limitations to minimize computationally intensive uses.

All the projects are open source. If you want to try Mapzen's products, you should start with the hosted services to see if they fit your workflow needs. If you later decide that you need additional customizations or higher capacity, you can consider installing on your own servers the open-source code used to build Mapzen's services. If you find an issue or have enhancement suggestions for Mapzen's products, send a note to hello@mapzen.com or add an issue to the GitHub project.

If you need higher limits on the Mapzen-hosted services, contact hello@mapzen.com for more information.

To check your usage, sign in to your developer account.

1. Sign in at https://mapzen.com/developers.
2. Click the statistics button for the API key you want to review.
3. View a graph of your recent usage for a certain period of time, such as the past day or month. 

You also receive [HTTP status codes](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes) in the header for the server's response to your query.

### Maps

Tangram, Mapzen's rendering software for web and mobile apps, does not require its own API key. However, if you are using Tangram to draw data from Mapzen's vector tiles service, you need a vector tiles key.

Vector tiles provides global basemap coverage and has these limits:

- 100 queries per second
- 2,000 queries per minute
- 100,000 queries per day

You may cache the tiles for offline use, but cannot bundle the tiles for purposes of reselling them.

The Mapzen vector tiles service is built from the [Tilezen](https://github.com/tilezen) open-source project.

### Search and mobility

_Mapzen Search_ is a geocoding and place-finding service and has these limits:

- 6 queries per second
- 30,000 queries per day

Mapzen Search is a web service that is built upon the code from the open-source geocoder project called Pelias.  It's best to start with the service; only if you need very high rate limits or custom tools should you run your own instance of Pelias.

The Mapzen Search service is built from the [Pelias](https://github.com/pelias) open-source project.

_Mapzen Turn-by-Turn_ is a routing and navigation service and has these limits:

- 2 queries per second
- 50,000 queries per day
- Pedestrian routes have a limit of 50 locations and 250 kilometers.
- Bicycle routes have a limit of 50 locations and 500 kilometers.
- Automobile routes have a limit of 20 locations and 5,000 kilometers.

The distance limit is the total straight-line distance (colloquially, "as the crow flies") along a path through successive locations.

The Mapzen Turn-by-Turn, Matrix, and Elevation services are built from the [Valhalla](https://github.com/valhalla) open-source project.

_Mapzen Matrix_ provides time and distance calculations between locations and has these limits:

- 2 queries per second
- 5,000 queries per day
- The maximum number of locations is 50 for any type of matrix.
- The maximum straight-line distance between two locations is 200 kilometers.

_Mapzen Elevation_ provides the height or elevation at a set of locations and has these limits:

- 2 queries per second
- 20,000 queries per day

There are also limitations on the number of sampling points for which you request elevations.

### Data products

Other than the vector tiles service, Mapzen's data products do not currently require API keys. These include:

- Who's on First, the global gazetteer
- Metro Extracts, downloadable snapshots of OpenStreetMap data
- Transitland, the open transit data project

## Terms of use

Mapzen's products are available for any use, including commercial purposes. You need to follow the attribution requirements for the data source, and also provide acknowledgement to Mapzen if you are using these web services.
