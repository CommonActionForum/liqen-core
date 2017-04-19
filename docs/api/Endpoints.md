# Endpoints

Here are described all 17 endpoints of the API. All `GET` operations except `GET /users/:id` can be performed without an access token.

## GET /users/:id

Retrieve the information of an user giving its ID. The user in the access token must match with the requested user.

#### Example of successful (**200**) response

```json
{
    "id": 1,
    "email": "john@example.com"
}
```

## POST /sessions
## GET /tags
## GET /tags/:id
## GET /articles
## GET /articles/:id
## GET /annotations
## GET /annotations/:id
## PATCH /annotations/:id
## DELETE /annotations/:id
## GET /questions
## GET /questions/:id
## GET /leeqs
## GET /leeqs/:id
## POST /leeqs
## PATCH /leeqs/:id
## DELETE /leeqs/:id
