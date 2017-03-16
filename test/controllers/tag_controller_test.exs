defmodule Core.TagControllerTest do
  use Core.ConnCase

  setup do
    user = insert_user(%{})
    {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user)
    {:ok, %{conn: build_conn(), jwt: jwt}}
  end

  test "Forbid certain actions for unauthenticated users", %{conn: conn} do
    Enum.each([
      put(conn, tag_path(conn, :update, "123", %{})),
      post(conn, tag_path(conn, :create, %{})),
      delete(conn, tag_path(conn, :delete, "123")),
    ], fn conn ->
      assert json_response(conn, 401)
      assert conn.halted
    end)
  end

  test "Do not require user authentication on certain actions", %{conn: conn} do
    Enum.each([
      get(conn, tag_path(conn, :index)),
      get(conn, tag_path(conn, :show, "123")),
    ], fn conn ->
      assert json_response(conn, 200) || json_response(conn, 404)
    end)
  end

  test "Return some 422", %{conn: c, jwt: jwt} do
    conn = put_req_header(c, "authorization", "Bearer #{jwt}")

    Enum.each([
      post(conn, tag_path(conn, :create, %{})),
    ], fn conn ->
      assert json_response(conn, 422)
    end)
  end

  test "Return some 404", %{conn: c, jwt: jwt} do
    conn = put_req_header(c, "authorization", "Bearer #{jwt}")

    Enum.each([
      put(conn, tag_path(conn, :update, "123", %{})),
      delete(conn, tag_path(conn, :delete, "123")),
    ], fn conn ->
      assert json_response(conn, 404)
    end)
  end
end
