defmodule Core.SessionController do
  use Core.Web, :controller

  alias Core.Repo
  alias Core.Auth

  def create(conn, %{"email" => email,
                     "password" => password}) do

    case Auth.login(conn, email, password, repo: Repo) do
      {:ok, conn} ->
        jwt = conn.assigns.current_session.jwt
        expires = conn.assigns.current_session.exp

        conn
        |> put_resp_header("authorization", "Bearer #{jwt}")
        |> put_resp_header("x-expires", to_string(expires))
        |> put_status(:ok)
        |> render("ok.json", session: conn.assigns.current_session)

      {:error, _reason, _conn} ->
        conn
        |> put_status(:unauthorized)
        |> render("unauthorized.json", %{})
    end
  end

  def delete(_conn, _params) do
  end
end
