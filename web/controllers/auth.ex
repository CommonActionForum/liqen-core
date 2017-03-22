defmodule Core.Auth do
  @moduledoc """
  Phoenix Plug and

  This module is used for creating sessions and for checking user permissions.

  ## Create sessions

  Use the login function to create a session


  ## Use as Plug to verify user permissions

  ```
  plug Core.Auth %{key: :annotation,
                   type: "annotations"}
  ```
  """
  use Core.Web, :controller

  import Plug.Conn
  import Comeonin.Bcrypt, only: [checkpw: 2]

  alias Core.User

  @doc """
  Init function of the Plug
  """
  def init(opts), do: opts

  @doc """
  Call function of the Plug
  """
  def call(conn, %{key: key, type: type}) do
    call(conn, %{resource: conn.assigns[key],
                 type: type,
                 action: action_name(conn)})
  end
  def call(conn, %{resource: resource, type: type, action: action}) do
    conn
    |> validate_session()
    |> validate_permissions(resource, type, to_string(action))
  end

  # Check if the token in the connection is valid
  defp validate_session(conn) do
    token = Guardian.Plug.current_token(conn)

    case Guardian.decode_and_verify(token) do
      {:ok, _} ->
        conn
      {:error, _} ->
        conn
        |> put_status(:unauthorized)
        |> render(Core.ErrorView, "401.json", %{})
        |> halt()
    end
  end

  # Check if the user in session has permissions to do an `action`
  # to the resource of type type
  defp validate_permissions(conn = %Plug.Conn{halted: true}, _, _, _), do: conn
  defp validate_permissions(conn, resource, type, action) do
    user = Guardian.Plug.current_resource(conn)
    valid = case resource do
              %{author: _} -> User.can?(user, action, type, resource)
              _ -> User.can?(user, action, type)
            end

    if valid do
      conn
    else
      conn
      |> put_status(:forbidden)
      |> render(Core.ErrorView, "403.json", %{})
      |> halt()
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
