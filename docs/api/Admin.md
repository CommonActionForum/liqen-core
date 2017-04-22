# Endpoints for admin users

Some endpoints are only accessible by admin users. Currently there is no way to create new admin users, so, unless your user is admin, you will get a `403 Forbidden` error code in all the following requests.

## POST /users

Create a new user giving its e-mail and password.

#### Example request

```json
{
    "e-mail": "john@example.com",
    "password": "secret"
}
```

#### Example of successful response

```json
{
    "id": 1,
    "e-mail": "john@example.com"
}
```


## DELETE /users/:id
## PUT /tags/:id
## POST /tags
## DELETE /tags/:id
## POST /articles
## DELETE /articles/:id
## POST /questions

Create a new question

#### Example request

```json
{
    "title": "¿Cuál es la dinámica de las personas altamente cualificadas?",
    "answer": [
        {
            "tag": 1,
            "required": true
        },
        {
            "tag": 2,
            "required": true
        },
        {
            "tag": 3,
            "required": true
        }
    ]
}
```

## PUT /questions/:id

Edit a question

#### Example request 1. Changing the title

```json
{
    "title": "Who is the writer of El Quijote"
}
```

#### Example request 2. Changing expected answer

```json
{
    "answer": [
        {
            "tag": 1,
            "required": false
        }
    ]
}
```

The change only will be performed if all tags exist.

Note that changing the expected answer can cause several side-effects. Valid Liqs can become invalid ones.

## DELETE /questions/:id
