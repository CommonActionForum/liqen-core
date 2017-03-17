defmodule Core.ArticleControllerTest do
  use Core.ConnCase

  setup do
    user = insert_user(%{})
    article = insert_article(%{})

    {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user)
    {:ok, %{conn: build_conn(), jwt: jwt, article: article}}
  end

  test "Forbid certain actions for unauthenticated users", %{conn: conn} do
    Enum.each([
      put(conn, article_path(conn, :update, "123", %{})),
      post(conn, article_path(conn, :create, %{})),
      delete(conn, article_path(conn, :delete, "123")),
    ], fn conn ->
      assert json_response(conn, 401)
      assert conn.halted
    end)
  end

  test "Do not require user authentication on certain actions", %{conn: conn, article: article} do
    Enum.each([
      get(conn, article_path(conn, :index)),
      get(conn, article_path(conn, :show, article.id)),
    ], fn conn ->
      assert json_response(conn, 200)
    end)
  end

  test "Return some 404 for unauthenticated users", %{conn: conn} do
    conn = conn
    |> get(article_path(conn, :show, 0))

    assert json_response(conn, 404)
  end

  test "Return some 422", %{conn: c, jwt: jwt} do
    conn = put_req_header(c, "authorization", "Bearer #{jwt}")

    Enum.each([
      post(conn, article_path(conn, :create, %{})),
    ], fn conn ->
      assert json_response(conn, 422)
    end)
  end

  test "Return some 404", %{conn: c, jwt: jwt} do
    conn = put_req_header(c, "authorization", "Bearer #{jwt}")

    Enum.each([
      put(conn, article_path(conn, :update, "123", %{})),
      delete(conn, article_path(conn, :delete, "123")),
    ], fn conn ->
      assert json_response(conn, 404)
    end)
  end
end
