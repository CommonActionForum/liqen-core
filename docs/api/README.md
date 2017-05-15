# API Reference

This documentation is intended to get you up-and-running with the Liqen APIs. We'll cover everything you need to know, from authentication, to manipulating results, to combining results with other services.

## Schema

All API access is over HTTPS, and accessed through `https://liqen-core.herokuapp.com`. All data is sent and received as **JSON**. Make sure to specify the `Content-type: application/json` header.

## Clients

We are currently developing an Official Liqen Client for JavaScript. It converts the JSON responses into JavaScript objects.

{% method %}

{% sample lang="js" %}

In JavaScript, get the [Liqen](https://www.npmjs.com/package/liqen) package from NPM.

Then, call the exposed function to create an instance of the client.

```js
const liqen = require('liqen')
const core = liqen()
```

You can call the function `liqen` passing an `access_token` argument. Then, every request to the Liqen API, will be made with the passed token.

```js
const liqen = require('liqen')
const core = liqen('hg8ue9jf09ajd0jge09dps')
```

See [Auth](Auth.md) for details.

{% endmethod %}

## Other content types

In a short-term future, it is planned to allow two more content types:

- HTML
- JSON-LD
