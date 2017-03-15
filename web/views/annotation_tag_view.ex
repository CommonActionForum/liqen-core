defmodule Core.AnnotationTagView do
  use Core.Web, :view

  def render("show.json", %{tag: tag}) do
    render_one(tag, Core.AnnotationView, "tag.json")
  end

  def render("tag.json", _) do
    %{"messsage": "done!"}
  end
end
