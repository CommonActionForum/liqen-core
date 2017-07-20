defmodule Core.Auth do
  @moduledoc """
  This module handles user sessions, authentication and authorization.

  To check authentication/authorization of a user, `plug` this in a controller.

  ### Authentication/authorization. Plug usage

  If the User is not authenticated, the plug will halt the connection, respond
  a `401` error and render a `"401.json"` template from `Core.Web.ErrorView`.

  If the User is authenticated but doesn't have the proper permissions, the
  plug will halt the connection, respond a `403` error and render a `"403.json"`
  from `Core.Web.ErrorView`.

  #### Options

  Options must be passed to the plug using a map with the fields:

  - `key`. The plug will retrieve the resource `from conn.assigns[key]`
  - `type`. The name of the resource. See `Core.User.can?/3` and
    `Core.User.can?/4`

  #### Usage example

  This checks permissions for the resource "annotations", which object is
  located in `conn.assgins.annotation`

  ```
  plug Core.Auth, %{key: :annotation, type: "annotations"}
  ```
  """
  @behaviour Plug
  use Core.Web, :controller

  import Plug.Conn

  alias Core.User

  @doc """
  Implements `c:Plug.init/1`
  """
  def init(opts), do: opts

  @doc """
  Implements `c:Plug.call/2`
  """
  def call(conn, opts)
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
        |> render(Core.Web.ErrorView, "401.json", %{})
        |> halt()
    end
  end

  # Check if the user in session has permissions to do an `action`
  # to the resource of type type
  defp validate_permissions(conn = %Plug.Conn{halted: true}, _, _, _), do: conn
  defp validate_permissions(conn, resource, type, action) do
    user = Guardian.Plug.current_resource(conn)
    valid =
      case resource do
        nil ->
          Core.Permissions.can?(user, action, type)

        _ ->
          Core.Permissions.can?(user, action, type, resource)
      end

    if valid do
      conn

    else
      conn
      |> put_status(:forbidden)
      |> render(Core.Web.ErrorView, "403.json", %{})
      |> halt()
    end
  end

  @doc """
  Handles requests that doesn't pass the authentication/authorization
  """
  def unauthenticated(conn, _params) do
    conn
    |> put_status(:unauthorized)
    |> render(Core.Web.ErrorView, "401.json", %{})
  end
end
