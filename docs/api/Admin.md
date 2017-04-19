# Endpoints for admin users

Some endpoints are only accessible by admin users. Currently there is no way to create new admin users, so, unless your user is admin, you will get a `403 Forbidden` error code in all the following requests.

## POST /users

Create a new user giving its e-mail and password.

#### Example request

```json
{
    "email": "john@example.com",
    "password": "secret"
}
```

#### Example of successful (**201**) response

```json
{
    "id": 1,
    "email": "john@example.com"
}
```


## DELETE /users/:id
## PUT /tags/:id
## POST /tags
## DELETE /tags/:id
## POST /articles
## DELETE /articles/:id
## POST /questions
## PUT /questions/:id
## DELETE /questions/:id
