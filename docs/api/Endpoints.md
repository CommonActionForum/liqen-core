# Endpoints

Here are described all 16 endpoints of the API. All `GET` operations except `GET /users/:id` can be performed without an access token.

## GET /users/:id

Retrieve the information of an user giving its ID. The user in the access token must match with the requested user.

#### Example of successful (**200**) response

```json
{
    "id": 1,
    "email": "john@example.com"
}
```

## GET /tags

Retrieve a list of tags

#### Example of successful response

```json
[
    {
        "id": 1,
        "title": "Person"
    },
    {
        "id": 2,
        "title": "Thing"
    }
]
```

## GET /tags/:id

Retrieve a tag.

#### Example of successful response

```json
{
    "id": 1,
    "title": "Employer",
    "source": {
        "uri": "http://vocab.org/bio/#employer"
    }
}
```

## GET /articles

Retrieve a list of articles

#### Example of successful response

```json
[
    {
        "id": 1,
        "title": "My first article"
    }
]
```

## GET /articles/:id

Retrieve an article

#### Example of successful response

```json
{
    "id": 2,
    "title": "Fuga de cerebros: ¿dolor de cabeza para Latinoamérica?",
    "source": {
        "uri": "http://www.bancomundial.org/es/news/feature/2013/11/06/fuga-cerebros-latinoamerica",
        "target": {
            "value": "/html/body/div[6]/div[1]/div[2]/div[1]/div[1]/div/div/div/div[2]/div[1]/div/div/div/div/div[3]/section/div",
            "type": "XPathSelector"
        }
    }
}
```

## GET /annotations

Retrieve a list of annotations

#### Example of successful response

```json
[
    {
        "id": 1,
        "author": 1,
        "article_id": 1,
        "target": {
            "type": "TextQuoteSelector",
            "suffix": " que ha visto emigraciones de hasta 90% en algunos países del Caribe.",
            "prefix": "Mientras la anémica creación de empleo sigue siendo el Talón de Aquiles de la recuperación económica en EE.UU y Europa, muchos profesionales latinoamericanos ven mejores oportunidades en esas tierras, en un ",
            "exact": "éxodo"
        }
    },
    {
        "id": 2,
        "author": "1",
        "title": "País"
    }
]
```

## GET /annotations/:id

Get an annotation

#### Example of successful response

```json
{
    "id": 1,
    "author": 1,
    "article_id": 1,
    "target": {
        "type": "TextQuoteSelector",
        "prefix": "ven mejores oportunidades en esas tierras, en un ",
        "exact": "éxodo",
        "suffix": " que ha visto emigraciones"
    }
}
```

## POST /annotations

Create an annotation

#### Example request

```json
{
    "article_id": 3,
    "target": {
        "type": "FragmentSelector",
        "value": "id1"
    },
    "tags": [1]
>>>>>>> minimum-answer
}
```

## PATCH /annotations/:id

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

Delete an annotation

## GET /questions

Retrieve a list of questions

```json
[
    {
        "id": 1,
        "title": "¿Quién ganó la Liga en la temporada 2015-16?",
        "answer": []
    }
]
```

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

## GET /liqens
## GET /liqens/:id

Retrieve a Liqen

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

## POST /liqens

Creates a new Fact.

```json
{
    "question_id": 1,
    "annotations": [3, 2]
}
```

## PATCH /liqens/:id

Modifies a Liqen

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
