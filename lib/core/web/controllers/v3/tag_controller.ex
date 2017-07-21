defmodule Core.Web.V3.TagController do
  use Core.Web, :controller
  alias Core.Q

  plug Core.Web.Authentication when action in []
  action_fallback Core.Web.FallbackController

  def index(conn, _params) do
    tags = Q.get_all_tags()
    json(conn, tags)
  end

  def show(conn, %{"id" => id}) do
    with {:ok, tag } <- Q.get_tag(id) do
      json(conn, tag)
    end
  end
end
