defmodule Core.Web.Authentication do
  @moduledoc """
  Handle the Authentication system.

  Sets conn.assign.current_user to a user object only if it is present in the
  token.

  Otherwise, halts the connection and responses a 401
  """

  @behaviour Plug
  use Core.Web, :controller

  def init(opts), do: opts

  def call(conn, _opts) do
    token = Guardian.Plug.current_token(conn)
    conn =
      with {:ok, claims} <- Guardian.decode_and_verify(token),
           {:ok, resource} <- Guardian.serializer.from_token(claims["sub"]) do
        conn
        |> assign(:current_user, resource)
      end

    case conn do
      {:error, _} ->
        conn
        |> put_status(:unauthorized)
        |> render(Core.Web.ErrorView, "401.json", %{})
        |> halt()

      conn ->
        conn
    end
  end
end
