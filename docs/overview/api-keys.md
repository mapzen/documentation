# Create and manage your Mapzen API keys

When signed in to your Mapzen developer account, you see a dashboard where you can create an API key, which is a code that uniquely links API usage inside your application with your Mapzen account without needing a password.

Mapzen's web services have various API endpoints that allow you to access web resources through a URL. You will need to include your API key in the URL you construct to send queries to Mapzen's services. For example, add an `api_key` URL parameter to any request, such as `?api_key=mapzen-xxxxxx`.

You must include an API key when using Mapzen's services; requests sent without an API key return errors.

## Create an API key

2. Go to https://mapzen.com.
2. Click your profile menu and click `Dashboard`. This is where you can create, delete, and manage your API keys.
4. Create a new Mapzen Key.
5. Optionally, give the key a name so you can remember the purpose of the project.
6. When you are ready to use it, copy the key and paste it into your code. In your query, the API key parameter should take the form of `api_key=your-mapzen-api-key`, substituting your actual API key for `your-mapzen-api-key`.

_Tip: The free rate limits are applied to your usage across your entire account. Creating multiple keys does not increase these limits._

## Protect your API keys
