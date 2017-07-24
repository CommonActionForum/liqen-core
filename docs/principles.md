# Design principles

{% method %}

For almost all resources of Liqen, we use CRUD operations following the RESTful API recommendations. In the officially maintained liqen libraries, we follow some conventions to name the methods that maps with the most common operations.

{% sample lang="bash" %}

## Conventions for HTTP methods

- `GET /collection` to retrieve a collection of items. (e.g. `GET /annotations`)
- `GET /collection/:id` to retrieve one item of the collection. (e.g. `GET /annotations/1`)
- `POST /collection` to create a new instance of the collection (e.g. `POST /annotations`)
- `PATCH /collection/:id` to edit one item of the collection. (e.g. `PATCH /annotations/1`)
- `DELETE /collection/:id` to delete one item of the collection. (e.g. `DELETE /annotations/1`)

{% sample lang="js" %}

## Conventions for JavaScript methods

- `core.collection.index()` to retrieve a collection of items (e.g. `core.annotations.index()`)
- `core.collection.show(:id)` to retrieve one item of the collection. (e.g. `core.annotations.show(1)`)
- `core.collection.create()` to create a new instance of the collection (e.g. `core.annotations.create()`)
- `core.collections.update(:id)` to edit one item of the collection. (e.g. `core.collections.update(:id)`)
- `core.collections.delete(:id)` to delete one item of the collection. (e.g. `core.collections.delete(:id)`)

{% endmethod %}

## Versioning

## Authentication

## Error handling

## Filter

## Pagination
