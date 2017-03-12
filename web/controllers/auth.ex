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
    access_token = get_req_header(conn, "Authorization")

    user = repo.get(User, 5)
    assign(conn, :current_user, user)
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
    session = %{
      access_token: "12345",
      token_type: "Bearer",
      expires_in: 3600*24*60
    }
    conn
    |> assign(:current_session, session)
  end
end
