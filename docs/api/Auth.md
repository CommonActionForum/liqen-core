# Authentication

To perform some operations, an access token will be needed. It allows you to make requests to the API on behalf of a user.

## A note on Authentication

> TL;DR: 401 = you need another token; 403 = the action is forbidden for you

Having an access token doesn't guarantee that all operations can be performed. Some requests are limited to certain users.

Depending on the response, you can guess what is the reason of the rejection. If the access token is not valid, a `401` error code will be responsed. If the token is correct but the user has no permissions, a `403` error code is returned.

{% method %}
## Obtain the access token

Send your account data (e-mail and password) to the endpoint and get the access token.

`POST /sessions`

### Parameters

Name     | Type   | Description
:---     | :---   | :----------
email    | string | **Required**. E-mail of the user
password | string | **Required**. Password of the user

{% sample lang="bash" %}
### Request

```bash
curl -v https://liqen-core.herokuapp.com/sessions \
    -H "Content-Type: application/json" \
    -d '{
        "email": "john@example.com",
        "password": "secret"
    }'
```

{% sample lang="js" %}
### Request

```js
// Create a liqen instance without access token
const liqen = require('liqen')()

//
liqen
  .sessions.create({
    email: 'john@example.com',
    password: 'secret'
  })
  .then(session => {
    // Display the retrieved object
    console.log(session.access_token)
    console.log(session.expires)
    console.log(session.user.id)
  })
```

{% common %}
### Example successful (**201**) response

```json
{
    "access_token": "EEwJ6tF9x5WCIZDYzyZGaz6Khbw7raYRIBV_WxVvgmsG",
    "expires": 1489358571,
    "user": {
        "id": 5
    }
}
```

{% endmethod %}

The access token will also be included in the `Authorization` header

{% method %}

## Use the token

{% sample lang="bash" %}

Include the `Authorization` header in the request with the value `Bearer <ACCESS_TOKEN>` to perform the operation.

```sh
curl -v https://liqen-core.herokuapp.com/annotations \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer EEwJ6tF9x5WCIZDYzyZGaz6Khbw7raYRIBV_WxVvgmsG" \
    -d '{
        "article_id": 1,
        ...
    }'
```

{% sample lang="js" %}

Once you get the token, construct a new Liqen instance, now passing the token:

```js
// Create a liqen instance with access token
const liqen = require('liqen')('EEwJ6tF9x5WCIZDYzyZGaz6Khbw7raYRIBV_WxVvgmsG')

//
liqen
  .annotations.create({
    article_id: 1,
    ...
  })
```

{% endmethod %}
