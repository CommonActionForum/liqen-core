defmodule Core.Web.V3.UserController do
  use Core.Web, :controller
  alias Core.Accounts.User

  plug Core.Web.Authentication

  action_fallback Core.Web.FallbackController

  def create(conn, params) do
    author = conn.assigns.current_user

    with {:ok, _} <-
           Core.Permissions.check_permissions(author, "create", "user"),
         {:ok, user} <-
           Core.Registration.create_account(params)
    do
      conn
      |> put_status(:created)
      |> render("created.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    author = conn.assigns.current_user

    with {:ok, user} <-
           Core.Accounts.get_user(id),
         {:ok, user} <-
           Core.Permissions.check_permissions(author, "show", "users", user)
    do
      conn
      |> put_status(:ok)
      |> render("show.json", user: user)
    end
  end
end
