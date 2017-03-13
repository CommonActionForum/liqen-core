defmodule Core.Auth do
  use Core.Web, :controller

  import Plug.Conn
  import Comeonin.Bcrypt, only: [checkpw: 2]

  alias Core.User

  @doc """
  Try to authenticate an user and if success, starts a session for him
  """
  def login(conn, email, pass, opts) do
    repo = Keyword.fetch!(opts, :repo)
    user = repo.get_by(User, email: email)

    cond do
      user && checkpw(pass, user.crypted_password) ->
        {:ok, create_session(conn, user)}
      true ->
        {:error, :unauthorized, conn}
    end
  end

  @doc """
  Handles requests that doesn't pass the authentication/authorization
  """
  def unauthenticated(conn, _params) do
    conn
    |> put_status(:unauthorized)
    |> render(Core.ErrorView, "401.json", %{})
  end

  defp create_session(conn, user) do
    new_conn = Guardian.Plug.api_sign_in(conn, user)
    jwt = Guardian.Plug.current_token(new_conn)

    case Guardian.Plug.claims(new_conn) do
      {:ok, claims} ->
        session = %{user: user, jwt: jwt, exp: Map.get(claims, "exp")}

        conn
        |> assign(:current_session, session)
      {:error, _} ->
        conn
        |> assign(:current_session, nil)
    end
  end
end
