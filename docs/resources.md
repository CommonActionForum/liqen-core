# Types and resources

These are the main **resources** in Liqen

1. Annotation. Plural: annotations
2. Article. Plural: articles
3. Liqen. Plural: liqens
4. Question. Plural: questions
5. Tag. Plural: tags
6. User. Plural: users

The following represents a **type**. We can considered them also like resources but without any URI associated to them.

1. Concept. Plural: concepts
2. Fragment. Plural: fragments

---

## Annotation

```js
{
  "id": String,        // Id of the annotation
  "author": User,      // Person who creates the annotation
  "source": Article,   // Reference to the information source
  "target": Fragment,  // Reference to the part of the information source
  "tags": [Tag],       // Tags of the annotation
  "type": Concept      // Semantic classification of the annotation
}
```

## Article

```js
{
  "id": String,  // Id of the article
  "uri": String  // Location of the article
}
```

## Concept

```js
{
  "id": String,  // Id of the concept
  "name": String // Human-friendly concept name
}
```

## Fragment

```js
{
  "type": "TextQuoteSelector", // Type of the fragment
  "prefix": String,            // Piece of text that comes before the text
                               // referenced
  "exact": String,             // The text referenced
  "suffix": String             // Piece of text that comes after the text
                               // referenced
}
```

## Liqen

```js
{
  "id": String,           // Id of the liqen
  "answers_to": Question, // The question answered by this liqen
  "body": [Annotation],   // The set of annotations
  "valid": Boolean        // Indicates if the liqen is a valid answer for the 
                          // answered question
}
```

## Question

```js
{
  "id": String,           // Id of the question
  "author": User,         // Author of the question
  "title": String,        // Human-friendly question title
  "required_tags": [Tag], // Minimal structure that a liqen should have to be 
                          // a valid answer of this question
  "optional_tags": [Tag]  // Extra information that a liqen could give to 
                          // answer this question
}
```

## Tag

```js
{
  "id": String,      // Id of the tag
  "name": String,    // Human-friendly tag name
  "types": [Concept] // Classification of a tag
}
```

## User

```js
{
  "id": String,   // Id of the user
  "name": String  // Name of the user
}
```


