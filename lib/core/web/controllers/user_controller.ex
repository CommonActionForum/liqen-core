defmodule Core.Web.UserController do
  use Core.Web, :controller
  alias Core.Accounts.User

  plug :find when action in [:show]
  plug Core.Web.Authentication

  action_fallback Core.Web.FallbackController

  def create(conn, params) do
    with {:ok, user} <- Core.Registration.create_account(params) do
      conn
      |> put_status(:created)
      |> render("created.json", user: user)
    end
  end

  def show(conn, _) do
    user = conn.assigns.user

    conn
    |> put_status(:ok)
    |> render(Core.Web.UserView, "show.json", user: user)
  end

  defp find(conn = %Plug.Conn{params: %{"id" => id}}, _opts) do
    case Core.Accounts.get_user(id) do
      {:ok, user} ->
        conn
        |> assign(:user, user)

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> render(Core.Web.ErrorView, "404.json", %{})
        |> halt()
    end
  end
end
