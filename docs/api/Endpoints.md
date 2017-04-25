# Endpoints

Here are described all 16 endpoints of the API. All `GET` operations except `GET /users/:id` can be performed without an access token.

## GET /users/:id

Retrieve the information of an user giving its ID. The user in the access token must match with the requested user.

#### Example of successful response

```json
{
    "id": 1,
    "e-mail": "john@example.com"
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

#### Example of request

```json
{
    "article_id": 1,
    "target": {
        "type": "TextQuoteSelector",
        "prefix": "ven mejores oportunidades en esas tierras, en un ",
        "exact": "éxodo",
        "suffix": " que ha visto emigraciones"
    }
}
```

## PATCH /annotations/:id

Edit an annotation

#### Example of request

```json
{
    "article_id": 1
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
## GET /leeqs
## GET /leeqs/:id
## POST /leeqs
## PATCH /leeqs/:id
## DELETE /leeqs/:id
