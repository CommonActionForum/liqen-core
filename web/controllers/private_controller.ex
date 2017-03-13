defmodule Core.PrivateController do
  use Core.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: Core.Auth

  def example(conn, _params) do
    conn
    |> put_status(:ok)
    |> render("ok.json", %{})
  end
end
