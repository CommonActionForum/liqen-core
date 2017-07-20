defmodule Core.UserControllerTest do
  @moduledoc """
  Test for Core.Web.V3.UserController
  """
  use Core.Web.ConnCase

  setup do
    user = insert_user()
    {:ok, jwt, _} = Guardian.encode_and_sign(user)

    conn = build_conn()
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", "Bearer #{jwt}")

    user_root = insert_user(%{}, true)
    {:ok, jwt, _} = Guardian.encode_and_sign(user_root)

    conn_root = build_conn()
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", "Bearer #{jwt}")

    {:ok, %{conn_root: conn_root,
            user_root: user_root,
            conn: conn,
            user: user}}
  end

  test "Create a user", %{conn_root: conn} do
    params = %{"email" => "john@example.com",
               "password" => "12345",
               "role" => "beta_user"}
    conn = conn
    |> post(v3_user_path(conn, :create, params))

    assert json_response(conn, :created)
  end

  test "Fail to create a user (not enough permissions)", %{conn: conn} do
    params = %{"email" => "john@example.com",
               "password" => "12345",
               "role" => "beta_user"}

    conn = conn
    |> post(v3_user_path(conn, :create, params))

    assert json_response(conn, :forbidden)
  end

  test "Retrieve a user", %{conn: conn, user: user} do
    conn = conn
    |> get(v3_user_path(conn, :show, user.id))

    assert json_response(conn, :ok)
  end

  test "Fail to retrieve a user (not enough permissions)", %{conn: conn, user_root: user} do
    conn = conn
    |> get(v3_user_path(conn, :show, user.id))

    assert json_response(conn, :forbidden)
  end

  test "Fail to retrieve a user (Resource not found)", %{conn_root: conn} do
    conn = get(conn, v3_user_path(conn, :show, 0))

    assert json_response(conn, :not_found)
  end

  test "Fail to retrieve a user (not enough permissions + Resource not found)", %{conn: conn} do
    conn = get(conn, v3_user_path(conn, :show, 0))

    assert json_response(conn, :not_found)
  end
end
