Mapzen's products help you put a map anywhere, search and route the planet, and try a world of open data. These are built from open-source tools that are packaged into a web service and hosted on Mapzen's servers. If you want to use Mapzen's services, you need to create a Mapzen developer account and a valid API key, and keep your requests to the service within certain rate limits.

## Developer accounts and API keys

Mapzen developer account authentication is through [GitHub](https://github.com), which is a website that enables people to collaborate on a project. You need to have a GitHub account to create a Mapzen developer account, as there is currently no other form of authentication.

When signed in to your Mapzen developer account, you see a dashboard where you can create an API key, which is a code that uniquely identifies your developer account without providing a password.

1. If you do not have a GitHub account, create one at https://github.com/join. It can be any kind, including personal.
2. Go to https://mapzen.com/developers. This is where you can create, delete, and manage your API keys.
3. Sign in with your GitHub account. If you have not done this before, you need to agree to the terms first.
4. Create a new key for the Mapzen product you want to use.
5. Optionally, give the key a name so you can remember the purpose of the project.
6. When you are ready to use it, copy the key and paste it into your code.

Mapzen's web services have various API endpoints that allow you to access web resources through a URL. You will need to include your API key in the URL you construct to send queries to Mapzen's services.   

## Rate limits
Mapzen offers a free tier of each service, subject to the rate limits listed below. The service shared resource, so there are limitations to prevent individual users from degrading system performance for everyone.

The services have maximum numbers of queries you can make within a certain period of time, and some have additional limitations to minimize computationally intensive uses.

All the projects used to build the Mapzen-hosted services are open source. If you want to try Mapzen's products, start with the hosted services to see if they fit your workflow needs. If you later decide that you need additional customizations or higher capacity, you can consider installing on your own servers the open-source code used to build Mapzen's services.

If you send a query without a valid API key (keyless access), the rate limits for Mapzen Search, Turn-by-Turn, Matrix, and Elevation are reduced to 1,000 requests per day, 6 per minute, and 1 per second.

If you find a problem, or have enhancement suggestions for Mapzen's products, send a note to hello@mapzen.com or add an issue to the GitHub project.

#### Check your usage

To check your usage, sign in to your developer account.

1. Sign in at https://mapzen.com/developers.
2. Click the statistics button for the API key you want to review.
3. View a graph of your recent usage for a certain period of time, such as the past day or month.

You also receive [HTTP status codes](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes) in the header for the server's response to your query.

If you exceed rate limits, you will typically see errors for 403 Forbidden and 429 Too Many Requests.

Mapzen uses server caching to deliver commonly requested content as quickly as possible. Queries that are served from a cache do not count toward your rate limits. For example, you might encounter results from the cache when you browse a map with vector tiles in a popular extent or repeatedly perform an identical geocoding search. 

### Mapping products

[Tangram](https://mapzen.com/documentation/tangram/), Mapzen's rendering software for web and mobile apps, does not require its own API key. However, if you are using Tangram to draw data from Mapzen's vector tiles service, you need a vector tiles key.

The [vector tiles](https://mapzen.com/documentation/vector-tiles/) service provides global basemap coverage and has these limits:

- 100 queries per second
- 2,000 queries per minute
- 100,000 queries per day

The Mapzen vector tiles service is built from the [Tilezen](https://github.com/tilezen) open-source project.

### Search and mobility products

#### Mapzen Search

[Mapzen Search](https://mapzen.com/documentation/search/) is a geocoding and place-finding service and has these limits:

- 6 queries per second
- 30,000 queries per day

The Mapzen Search service is built from the [Pelias](https://github.com/pelias) open-source project.

#### Mapzen Turn-by-Turn

[Mapzen Turn-by-Turn](https://mapzen.com/documentation/turn-by-turn/) is a routing and navigation service and has these limits:

- 2 queries per second
- 50,000 queries per day
- Pedestrian routes have a limit of 50 locations and 250 kilometers.
- Bicycle routes have a limit of 50 locations and 500 kilometers.
- Automobile routes have a limit of 20 locations and 5,000 kilometers.
- Multimodal routes have a limit of 500 kilometers between locations.

The distance limit is the total straight-line distance (colloquially, as the crow flies) along a path through successive locations.

#### Mapzen Matrix

[Mapzen Matrix](https://mapzen.com/documentation/matrix/) provides time and distance calculations between locations and has these limits:

- 2 queries per second
- 5,000 queries per day
- The maximum number of locations is 50 for any type of matrix.
- The maximum straight-line distance between two locations is 200 kilometers.

#### Mapzen Optimized Route

[Mapzen Optimized Route](https://mapzen.com/documentation/optimized/) finds the most efficient route between many locations. To use the Optimized Route service, you need a Matrix API key because the result is built with matrix calculations. The service has these limits:

- 2 queries per second
- 5,000 queries per day
- The maximum number of locations is 50.
- The maximum straight-line distance between two locations is 200 kilometers.

The Mapzen Turn-by-Turn, Matrix, and Optimized Route services are built from the [Valhalla](https://github.com/valhalla) open-source project.

### Data products

#### Mapzen Elevation

[Mapzen Elevation](https://mapzen.com/documentation/elevation/) provides the height or elevation at a set of locations and has these limits:

- 2 queries per second
- 20,000 queries per day

There are also limitations on the number of sampling points for which you request elevations.

The Mapzen Elevation lookup service is built from the [Valhalla](https://github.com/valhalla) open-source project.

#### Other data products

Mapzen's other data products do not currently require API keys. These include:

- Who's on First, the global gazetteer
- Metro Extracts, downloadable snapshots of OpenStreetMap data (Note: you will need to sign in with a developer account to download custom extracts)
- Transitland, the open transit data project

### Mobile products

To use Mapzen's Android SDK or any of Mapzen's other products in your mobile apps, you need an API key for the function you are integrating. For example, adding routing to your app requires a Mapzen Turn-by-Turn API key.

## Terms of use

Mapzen's products are available for any use, including commercial purposes. You need to follow the [attribution requirements](https://mapzen.com/rights/) for the data source, and also provide acknowledgement to Mapzen if you are using these web services.
