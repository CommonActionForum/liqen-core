defmodule Core.AnnotationView do
  use Core.Web, :view

  def render("index.json", %{annotations: annotations}) do
    %{data: render_many(annotations, Core.AnnotationView, "annotation.json")}
  end

  def render("show.json", %{annotation: annotation}) do
    %{data: render_one(annotation, Core.AnnotationView, "annotation.json")}
  end

  def render("annotation.json", %{annotation: annotation}) do
    %{id: annotation.id,
      article_id: annotation.article_id,
      author: annotation.author}
  end
end
