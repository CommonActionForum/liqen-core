# Authentication

To perform some operations, an access token will be needed. It allows you to make requests to the API on behalf of a user.

## A note on Authentication

> TL;DR: 401 = you need another token; 403 = the action is forbidden

Having an access token doesn't guarantee that all operations can be performed. Some requests are limited to certain users.

Depending on the response, you can guess what is the reason of the rejection. If the access token is not valid, a `401` error code will be responsed. If the token is correct but the user has no permissions, a `403` error code is returned.

## Obtain the access token

`POST /sessions`

If the e-mail and password pair are correct, an access token will be retrieved along with some data of the user.

### Parameters

Name     | Type   | Description
:---     | :---   | :----------
e-mail   | string | **Required**. E-mail of the user
password | string | **Required**. Password of the user

### Example response

```json
{
    "access_token": "EEwJ6tF9x5WCIZDYzyZGaz6Khbw7raYRIBV_WxVvgmsG",
    "expires": 1489358571,
    "user": {
        "id": 5
    }
}
```

The access token will also be included in the `Authorization` header

## Use the token

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
