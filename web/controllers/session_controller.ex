defmodule Core.SessionController do
  use Core.Web, :controller

  alias Core.Repo
  alias Core.Auth

  def create(conn, %{"email" => email,
                     "password" => password}) do

    case Auth.login(conn, email, password, repo: Repo) do
      {:ok, conn} ->
        conn
        |> put_resp_header("authorization", "Bearer #{conn.assigns.current_session.jwt}")
        |> put_resp_header("x-expires", to_string(conn.assigns.current_session.exp))
        |> put_status(:ok)
        |> render("ok.json", session: conn.assigns.current_session)

      {:error, _reason, _conn} ->
        conn
        |> put_status(:unauthorized)
        |> render("unauthorized.json", %{})
    end
  end

  def delete(conn, params) do
  end
end
