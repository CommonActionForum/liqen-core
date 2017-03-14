defmodule Core.AnnotationView do
  use Core.Web, :view

  def render("index.json", %{annotations: annotations}) do
    render_many(annotations, Core.AnnotationView, "summary.json")
  end

  def render("show.json", %{annotation: annotation}) do
    render_one(annotation, Core.AnnotationView, "annotation.json")
  end

  def render("summary.json", %{annotation: annotation}) do
    %{id: annotation.id,
      article_id: annotation.article_id,
      author: annotation.author}
  end

  def render("annotation.json", %{annotation: annotation}) do
    target = annotation.target
    tags = Enum.map(annotation.annotation_tags, fn(tag) -> %{id: tag.id,
                                                             title: tag.title} end)

    %{id: annotation.id,
      article_id: annotation.article_id,
      author: annotation.author,
      target: %{
        type: target.type,
        value: target.value,
        refinedBy: %{type: "TextQuoteSelector",
                     prefix: target.prefix,
                     exact: target.exact,
                     suffix: target.suffix}},
      tags: tags}
  end
end
