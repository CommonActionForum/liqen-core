# Endpoints

Here are described all 17 endpoints of the API. All `GET` operations except `GET /users/:id` can be performed without an access token.

## GET /users/:id

Retrieve the information of an user giving its ID. The user in the access token must match with the requested user.

#### Example of successful response

```json
{
    "id": 1,
    "e-mail": "john@example.com"
}
```

## POST /sessions
## GET /tags
## GET /tags/:id
## GET /articles
## GET /articles/:id
## GET /annotations
## GET /annotations/:id
## POST /annotations

Create a new Annotation

#### Example request

```json
{
    "article_id": 3,
    "target": {
        "type": "FragmentSelector",
        "value": "id1"
    },
    "tags": [1]
}
```

## PATCH /annotations/:id

Edit an annotation.

#### Example request 1. Editing the target

```json
{
    "target": {
        "type": "CssSelector",
        "value": "p",
        "refinedBy": {
            "type": "FragmentSelector",
            "value": "id1"
        }
    }
}
```

#### Example request 2. Editing the tag list

```json
{
    "tags": [1, 2]
}
```

## DELETE /annotations/:id
## GET /questions
## GET /questions/:id

Retrieve the information of a given question.

#### Example of successful (**200**) response

```json
{
    "id": 1,
    "author": 1,
    "title": "¿Cuál es la dinámica de las personas altamente cualificadas?",
    "answer": [
        {
            "tag": {
                "id": 1,
                "title": "Lugar de origen"
            },
            "required": true
        },
        {
            "tag": {
                "id": 2,
                "title": "Motivo"
            },
            "required": true
        },
        {
            "tag": {
                "id": 3,
                "title": "Lugar de destino"
            },
            "required": true
        }
    ]
}
```

## GET /facts
## GET /facts/:id

Retrieve a Fact

#### Example of successful (**200**) response

```json
{
    "id": 7,
    "question_id": 3,
    "annotations": [
        {
            "id": 3,
            "article": 1,
            "target": {
                "type" : "CssSelector",
                "value" : "p"
            },
            "tags": [1, 2],
        }
    ],
    "complete": true
}
```

## POST /facts

Creates a new Fact.

```json
{
    "question_id": 1,
    "annotations": [3, 2]
}
```

## PATCH /facts/:id

Modifies a Fact

#### Example request 1. Editing the question

```json
{
    "question_id": 1
}
```

#### Example request 1. Editing the annotations

```json
{
    "annotations": [3, 2]
}
```

## DELETE /facts/:id

Deletes a Fact
