defmodule Core.Web.SessionController do
  use Core.Web, :controller

  alias Core.Registration

  def create(conn, %{"email" => email,
                     "password" => password}) do

    case Registration.login_user(email, password) do
      {:ok, user} ->
        set_session(conn, user)

      :error ->
        conn
        |> put_status(:unauthorized)
        |> render("unauthorized.json", %{})
    end
  end

  def delete(_conn, _params) do
  end

  defp set_session(conn, user) do
    new_conn = Guardian.Plug.api_sign_in(conn, user)
    jwt = Guardian.Plug.current_token(new_conn)

    case Guardian.Plug.claims(new_conn) do
      {:ok, claims} ->
        session = %{user: user, jwt: jwt, exp: Map.get(claims, "exp")}

        conn
        |> put_resp_header("authorization", "Bearer #{jwt}")
        |> put_resp_header("x-expires", to_string(session.exp))
        |> put_status(:ok)
        |> render("ok.json", session: session)

      {:error, _} ->
        conn
        |> put_status(:internal_server_error)
        |> render("500.json", %{})
    end
  end
end
