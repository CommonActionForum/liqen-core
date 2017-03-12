defmodule Core.UserController do
  use Core.Web, :controller

  alias Core.User

  def create(conn, params) do
    changeset = User.changeset(%User{}, params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render("created.json", user: user)

      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> render("bad_request.json", errors: changeset.errors)
    end
  end
end
