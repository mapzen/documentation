This guide covers the basics of setting up and getting started with Mapzen Flex.

## 1. Sign up for a Mapzen account

Mapzen developer account authentication is through [GitHub](https://github.com), which is a website that enables people to collaborate on a project. Or you can do email sign up!

When signed in to your Mapzen developer account, you see a dashboard where you can create an API key, which is a code that uniquely links API usage inside your application with your account without needing a password.

1. If you do not have a GitHub account, create one at https://github.com/join. It can be any kind, including personal.
2. Email email email email email email email login

## 2. Developer accounts and API keys

1. Go to https://mapzen.com/developers. This is where you can create, delete, and manage your API keys.
2. Sign in with your GitHub account. If you have not done this before, you need to agree to the terms first.
3. Create a new Mapzen Key.
4. Optionally, give the key a name so you can remember the purpose of the project.
5. When you are ready to use it, copy the key and paste it into your code. In your query, the API key parameter should take the form of `api_key=mapzen-xxxxxx`.

Mapzen's web services have various API endpoints that allow you to access web resources through a URL. You will need to include your API key in the URL you construct to send queries to Mapzen's services. For example, add an `api_key` URL parameter to any request, such as `?api_key=mapzen-xxxxxx`.

## 3. Get started with Mapzen Products

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

## 4. Rate limits
Mapzen offers a free tier of each service, subject to the rate limits listed below. Mapzen's hosted services are shared resources, so there are limitations to prevent individual users from degrading system performance for everyone.

The services have maximum numbers of queries you can make within a certain period of time, and some have additional limitations to minimize computationally intensive uses.

All the projects used to build the Mapzen-hosted services are open source. If you want to try Mapzen's products, start with the hosted services to see if they fit your workflow needs. If you later decide that you need additional customizations, you can consider installing on your own servers the open-source code used to build Mapzen's services.

You must include an API key when using Mapzen's services; requests sent without an API key return errors.

If you find a problem, need higher limits, or have enhancement suggestions for Mapzen's products, send a note to hello@mapzen.com.

#### Check your usage

To check your usage, sign in to your developer account.

1. Sign in at https://mapzen.com/developers.
2. Click the statistics button for the API key you want to review.
3. View a graph of your recent usage for a certain period of time, such as the past day or month.

You also receive [HTTP status codes](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes) in the header for the server's response to your query.

If you exceed rate limits, you will typically see errors for 403 Forbidden and 429 Too Many Requests.

Mapzen uses server caching to deliver commonly requested content as quickly as possible. Queries that are served from a cache do not count toward your rate limits. For example, you might encounter results from the cache when you browse a map with vector tiles in a popular extent or repeatedly perform an identical geocoding search.

## 5. Adding or changing payment method

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

## 6. Setting a budget
