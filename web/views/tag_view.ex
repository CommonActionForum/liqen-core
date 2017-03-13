defmodule Core.TagView do
  use Core.Web, :view

  def render("index.json", %{tags: tags}) do
    render_many(tags, Core.TagView, "tag.json")
  end

  def render("show.json", %{tag: tag}) do
    render_one(tag, Core.TagView, "tag.json")
  end

  def render("tag.json", %{tag: tag}) do
    %{id: tag.id,
      title: tag.title}
  end
end
