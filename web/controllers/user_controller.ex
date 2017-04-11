defmodule Core.UserController do
  use Core.Web, :controller
  alias Core.User

  plug Guardian.Plug.EnsureAuthenticated, %{handler: Core.Auth}
  plug :authorize

  def create(conn, params) do
    changeset = User.changeset(%User{}, params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render("created.json", user: user)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Core.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Guardian.Plug.current_resource(conn)

    if Repo.get(User, id) == user do
      conn
      |> put_status(:ok)
      |> render(Core.UserView, "show.json", user: user)

    else
      conn
      |> put_status(:forbidden)
      |> render(Core.ErrorView, "403.json", %{})
    end
  end

  defp authorize(conn, _opts) do
    user = Guardian.Plug.current_resource(conn)

    if User.can?(user, "super_user") do
      conn
    else
      conn
      |> put_status(:forbidden)
      |> render(Core.ErrorView, "403.json", %{})
      |> halt()
    end
  end
end
