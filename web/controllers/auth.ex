defmodule Core.Auth do
  import Plug.Conn
  import Comeonin.Bcrypt, only: [checkpw: 2]

  alias Core.User

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  @doc """
  Load the User object of a person with active session
  """
  def call(conn, repo) do
    access_token = get_req_header(conn, "authorization")
    IO.puts(access_token)

    case access_token do
      "12345" ->
        user = repo.get(User, 5)
        assign(conn, :current_user, user)
      _ ->
        assign(conn, :current_user, nil)
    end
  end

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

  defp create_session(conn, user) do
    new_conn = Guardian.Plug.api_sign_in(conn, user)

    session = %{
      user: user,
      jwt: Guardian.Plug.current_token(new_conn),
      exp: Guardian.Plug.claims(new_conn) |> Map.get("exp")
    }

    conn
    |> assign(:current_session, session)
  end
end
