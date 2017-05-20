defmodule Core.Web.UserController do
  use Core.Web, :controller
  alias Core.User

  plug :find when action in [:show]
  plug Core.Auth, %{key: :user,
                    type: "users"} when action in [:show]

  def create(conn, params) do
    changeset = User.registration_changeset(%User{}, params)

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

  def show(conn, _params) do
    user = Guardian.Plug.current_resource(conn)

    conn
    |> put_status(:ok)
    |> render(Core.UserView, "show.json", user: user)
  end

  defp find(conn = %Plug.Conn{params: %{"id" => id}}, _opts) do
    case Repo.get(User, id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> render(Core.ErrorView, "404.json", %{})
        |> halt()

      user ->
        conn
        |> assign(:user, user)
    end
  end
end
