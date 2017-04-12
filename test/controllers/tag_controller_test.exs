defmodule Core.TagControllerTest do
  @moduledoc """
  Test for Core.TagController
  """
  use Core.ConnCase

  setup do
    user = insert_user(%{}, true)
    {:ok, jwt, _} = Guardian.encode_and_sign(user)

    conn = build_conn()
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", "Bearer #{jwt}")

    {:ok, %{conn: conn}}
  end

  test "List of Tags", %{conn: conn}  do
    conn = conn
    |> get(tag_path(conn, :index))

    assert json_response(conn, :ok)
  end

  test "Create a tag", %{conn: conn} do
    conn1 = conn
    |> post(tag_path(conn, :create), %{"title" => "x"})

    conn2 = conn
    |> post(tag_path(conn, :create), %{"title" => ""})

    assert json_response(conn1, :created)
    assert json_response(conn2, :unprocessable_entity)
  end

  test "Show a tag", %{conn: conn} do
    tag = insert_tag()

    conn = conn
    |> get(tag_path(conn, :show, tag.id))

    assert json_response(conn, :ok)
  end

  test "Update a tag", %{conn: conn} do
    tag = insert_tag()

    conn1 = conn
    |> put(tag_path(conn, :update, tag.id), %{"title" => "b"})

    conn2 = conn
    |> put(tag_path(conn, :update, tag.id), %{"title" => ""})

    assert json_response(conn1, :ok)
    assert json_response(conn2, :unprocessable_entity)
  end

  test "Delete a tag", %{conn: conn} do
    tag = insert_tag()

    conn = conn
    |> delete(tag_path(conn, :delete, tag.id))

    assert response(conn, :no_content)
  end

  test "Resource not found", %{conn: conn} do
    conn1 = get(conn, tag_path(conn, :show, 0))
    conn2 = get(conn, tag_path(conn, :update, 0, %{}))
    conn3 = get(conn, tag_path(conn, :delete, 0))

    assert json_response(conn1, :not_found)
    assert json_response(conn2, :not_found)
    assert json_response(conn3, :not_found)
  end
end
