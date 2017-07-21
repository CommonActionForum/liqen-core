defmodule Core.Web.V3.TagControllerTest do
  @moduledoc """
  Test for Core.Web.V3.TagController
  """
  use Core.Web.ConnCase

  setup do
    t1 = insert_tag()
    t2 = insert_tag()
    t3 = insert_tag()
    t4 = insert_tag()
    t5 = insert_tag()

    conn =
      build_conn()
      |> put_req_header("accept", "application/json")

    {:ok, %{conn: conn,
            tags: [t1, t2, t3, t4, t5]}}
  end

  test "index", %{conn: conn} do
    conn =
      conn
      |> get(v3_tag_path(conn, :index))

    assert json_response(conn, :ok)
  end

  test "show successfully", %{conn: conn, tags: [t1, _, _, _, _]} do
    conn =
      conn
      |> get(v3_tag_path(conn, :show, t1.id))

    assert json_response(conn, :ok)
  end

  test "show when not-found", %{conn: conn} do
    conn =
      conn
      |> get(v3_tag_path(conn, :show, 0))

    assert json_response(conn, :not_found)
  end
end
