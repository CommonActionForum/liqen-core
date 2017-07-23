defmodule Core.ConceptView do
  use Core.Web, :view

  def render("index.json", %{concepts: concepts}) do
    render_many(concepts, Core.ConceptView, "summary.json")
  end

  def render("show.json", %{concept: concept}) do
    render_one(concept, Core.ConceptView, "concept.json")
  end

  def render("summary.json", %{concept: concept}) do
    %{id: concept.id,
      name: concept.name,
      uri: concept.uri}
  end

  def render("concept.json", %{concept: concept}) do
    %{id: concept.id,
      name: concept.name,
      uri: concept.uri}
  end
end
