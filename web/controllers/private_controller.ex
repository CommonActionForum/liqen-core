defmodule Core.PrivateController do
  use Core.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__

  def example(conn, _params) do
    user = Guardian.Plug.current_resource(conn)

    conn
    |> put_status(:ok)
    |> render("ok.json", %{})
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_status(:unauthorized)
    |> render("unauthorized.json", message: "Authentication required")
  end
end
