defmodule Core.UserController do
  use Core.Web, :controller

  def create(conn, params) do
    registration = %{}

    conn
    |> put_status(403)
    |> render("forbidden.json", registration: registration)
  end
end
