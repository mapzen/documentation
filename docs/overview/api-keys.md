# Create and manage your Mapzen API keys

When signed in to your Mapzen account, you can access a dashboard that allows you to create, manage, and track the usage of your Mapzen API keys. An API key is a code that uniquely links API usage inside your application with your Mapzen account without needing a password.

Mapzen's web services have various API endpoints that allow you to access web resources through a URL. You will need to include your API key in the URL you construct to send requests to Mapzen's services. For example, add an `api_key` URL parameter to any request, such as `?api_key=your-mapzen-api-key`. An API key works for any Mapzen service.

You must include an API key when using Mapzen's services; requests sent without an API key return errors.

## Create an API key

1. Go to https://mapzen.com.
2. In the top corner of the page, click `Account` and click `Dashboard`. This is where you can create, delete, and manage your API keys.
3. Create a new key.
4. Optionally, give the key a name so you can remember the purpose of the project.
5. When you are ready to use it, copy the key and paste it into your code. In your query, the API key parameter should take the form of `api_key=your-mapzen-api-key`, substituting your actual API key for `your-mapzen-api-key` part of the example.

_Note: The free rate limits are applied to your usage across your entire account. Creating multiple keys does not increase these limits._

## Choose an API key strategy for your app

The simplest workflow is for your app to employ a centralized API key for all users. This could mean that you deploy your app with a single key with enough capacity to cover all of your users’ usage. A valid variation is to create and deploy multiple keys if you want to monitor usage and billing for a particular client or function within your app.

In this model, the API keys in your app are linked to your Mapzen account. This makes you responsible for the costs associated with all of the usage for the keys that are deployed in your app. You can set a spending limit on your account to avoid unexpected charges, although be aware that the app may not function after the spending limit is reached.

The alternative and more complex API key workflow is for your app to provide an option for users to enter an API key from their own Mapzen accounts. Doing this allows your users to have their own free rate limits, and makes them individually liable for their usage costs. If you implement this method, your app should clearly indicate that a valid Mapzen API key is required. Otherwise, your users will see errors if they fail to include an API key when using Mapzen's services.

## Protect your API keys

If you want to keep your API key private, you can consider using a proxy system to hide the key from your users.

If you believe your API key has been compromised or used without your knowledge, contact [Mapzen](mailto:support@mapzen.com). You can also delete API keys or rotate them periodically in your app. There is not currently a default way to limit an API key for usage only on a particular web domain.

### Example with mapzen.js

When using [mapzen.js](https://mapzen.com/documentation/mapzen-js/), in your YAML scene file that defines the Tangram map, add a `sources` parameter for the API key.

```
sources:
    mapzen:
        [...]
        url_params:
            api_key: global.sdk_mapzen_api_key
```

Then, in the JavaScript, use your actual key in place of `your-mapzen-api-key` in this code.

```
var map = L.Mapzen.map('map', {
    tangramOptions: {
        scene: {
            [...]
            global: {
            sdk_mapzen_api_key: 'your-mapzen-api-key'
            }
        }
    }
}
```

### Example with separate Tangram scene files

A method of obfuscating the API key is put it in a separate YAML file and use an `import:` statement to link to it from your main Tangram scene file.

1. Import the file.

    There are several ways you can do this.

    - all on one line
        ```yaml
        import: https://your-file-url.yaml #link to your YAML file
        ```
    - as an array
        ```yaml
        import: [https://your-file-url.yaml] #link to your YAML file
        ```
    - as an unordered list:
        ```yaml
        import:
        - https://your-file-url.yaml #link to your YAML file
        ```

    The array or unordered list methods allow more than one import at a time:

    ```yaml
    import: [https://your-file-url.yaml, https://a-second-file-url.yaml]
    ```

    ```yaml
    import:
        - https://your-file-url.yaml #link to your YAML file
        - https://a-second-file-url.yaml #link to your YAML file
    ```

    Note that if the file is local, you do not need the protocol:

    ```yaml
    import: your-file.yaml #link to your YAML file
    ```

2. Reference the API key in the scene file.

    In your `sources` block, add `url_params`.

    ```yaml
    sources:
        mapzen:
            [...]
            url_params:
                api_key: global.sdk_mapzen_api_key
    ```

3. In your external file, define the key in a `global:` block.

    ```yaml
    global:
        sdk_mapzen_api_key: your-mapzen-api-key
    ```
