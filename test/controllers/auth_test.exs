defmodule Core.AuthTest do
  @moduledoc """
  Test for Core.Auth
  """
  use Core.Web.ConnCase
  alias Core.Auth

  setup do
    # Create an user
    user = insert_user(%{email: "matt@example.com",
                         password: "secret"})

    {:ok, jwt, _} = Guardian.encode_and_sign(user)
    {:ok, %{user: user, jwt: jwt}}
  end

  test "the Plug with non-valid session" do
    conn = build_conn()
    |> Auth.call(%{resource: %{}, type: "", action: :create})

    assert response(conn, :unauthorized)
    assert conn.halted
  end

  test "the Plug with valid session but non-valid perms", %{jwt: jwt} do
    conn = build_conn()
    |> bypass_through(Core.Web.Router, [:api])
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", "Bearer #{jwt}")
    |> get("/annotations")
    |> Auth.call(%{resource: %{}, type: "super_user", action: :create})


    assert response(conn, :forbidden)
    assert conn.halted
  end

  test "the Plug with valid sessions and valid perms", %{jwt: jwt} do
    conn = build_conn()
    |> bypass_through(Core.Web.Router, [:api])
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", "Bearer #{jwt}")
    |> get("/annotations")
    |> Auth.call(%{resource: nil, type: "annotations", action: :create})

    refute conn.halted
  end

  test "the Plug with non-valid perms (authored resource given)", %{jwt: jwt} do
    conn = build_conn()
    |> bypass_through(Core.Web.Router, [:api])
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", "Bearer #{jwt}")
    |> get("/annotations")
    |> Auth.call(%{resource: %{author: 0}, type: "annotations", action: :create})

    assert response(conn, :forbidden)
    assert conn.halted
  end
end
