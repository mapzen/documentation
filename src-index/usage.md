## Check your usage

To check your usage, sign in to your developer account.

1. Sign in at https://mapzen.com/developers.
2. Click the statistics button for the API key you want to review.
3. View a graph of your recent usage for a certain period of time, such as the past day or month.

You also receive [HTTP status codes](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes) in the header for the server's response to your query.

If you exceed rate limits, you will typically see errors for 403 Forbidden and 429 Too Many Requests.

Mapzen uses server caching to deliver commonly requested content as quickly as possible. Queries that are served from a cache do not count toward your rate limits. For example, you might encounter results from the cache when you browse a map with vector tiles in a popular extent or repeatedly perform an identical geocoding search.

## Caching to improve performance

Several Mapzen services, including [Search](https://mapzen.com/documentation/search/) and [Vector tiles](https://mapzen.com/documentation/vector-tiles/), use caching to serve commonly requested content as quickly as possible. An edge cache, also known as a content delivery network (CDN), is a network of computers, geographically spread across the world, designed to shorten the physical distance data must travel to you so it can get there faster. If you have ever tried to access a common service and found that it is slow, it may be because the information must travel a large physical distance. Mapzen Search and Vector Tiles use a CDN to help reduce this effect and limit the impact of common queries on its application servers.

Queries that are served from the edge cache do not count toward your limit of queries per second or queries per day, although you will still see them listed in your [dashboard](https://mapzen.com/developers/).

When you send a request to Mapzen Search or Vector Tiles, it first goes to the CDN server that is the closest path from your internet service provider before it is forwarded onto an application server. Mapzen Search and Vector tiles both use [Fastly](https://www.fastly.com) for its CDN; you can look at this [network map](https://www.fastly.com/network-map) to see where your requests are likely being sent.

If your request is not found in the current CDN cache, the CDN server then passes it to one of the Mapzen Search or Vector Tiles application servers. When it comes back with a response to your API call, the CDN server keeps a copy of that response (minus any personal data to your application, including your API key). If you or another nearby user makes the identical API call, you will likely be sent to the same CDN server, which has the response in its local cache. From tests in the Mapzen offices in New York, this has the effect of shortening a query from 190ms to 21ms. Your speed improvements may vary, as requests from other locations and internet providers may be served by different edge cache servers. The Mapzen Search cache is updated on the CDN at least once a week.

Through edge caching, common searches, such as `/v1/search?text=new york`, often come back quickly for most users, and may not count toward your rate limit. This is especially useful with Autocomplete, where many places start with the same few root letters, such as the `new` in `new york`, `newark`, and `new jersey`.

For Vector Tiles, zooms 0 - 10 are cached worldwide and will not count towards your rate limit. San Francisco, CA and New York, NY are fully cached to high zoom levels. Creating a request from the `all` layers option generally loads faster because these tiles are often served directly from Mapzen’s global tile cache. Custom layers experience a small lag because they are extracted, on demand, from all tiles and will count towards your rate limit.

Unless you have recently made a particular API call, you will not know ahead of time whether it will be served from the edge cache. After you make an API call, you can get more information in the HTTP headers of the response. HTTP headers are embedded metadata that tells your browser (or other software) how to make sense of the request.

These header entries are most helpful to determine whether caching was used:

- `X-Cache` indicates if your request was served from the Mapzen Search application server (`MISS`) or the cache server (`HIT`). This header should be there for any query you make to the Mapzen Search API. Any query with `X-Cache: MISS` is a query that counts toward your rate limit.
- `X-ApiaxleProxy-Qps-Left` is the number of queries per second remaining on your API key, and `X-ApiaxleProxy-Qpd-Left` is the remaining queries per day. These headers are only present when you see `X-Cache: MISS`.
