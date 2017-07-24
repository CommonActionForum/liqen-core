defmodule Core.TagView do
  use Core.Web, :view

  def render("index.json", %{tags: tags}) do
    render_many(tags, Core.TagView, "summary.json")
  end

  def render("show.json", %{tag: tag}) do
    render_one(tag, Core.TagView, "tag.json")
  end

  def render("summary.json", %{tag: tag}) do
      %{id: tag.id,
        title: tag.title}
  end

  def render("tag.json", %{tag: tag}) do
    concepts = Enum.map(tag.concepts, fn concept ->
      %{id: concept.id,
        name: concept.name}
    end)

    %{id: tag.id,
      title: tag.title,
      concepts: concepts}
  end
end
