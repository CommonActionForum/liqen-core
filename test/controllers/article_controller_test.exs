defmodule Core.ArticleControllerTest do
  use Core.ConnCase

  test "Requires user authentication on certain actions", %{conn: conn} do
    Enum.each([
      put(conn, article_path(conn, :update, "123", %{})),
      post(conn, article_path(conn, :create, %{})),
      delete(conn, article_path(conn, :delete, "123")),
    ], fn conn ->
      assert json_response(conn, 401)
      assert conn.halted
    end)
  end

  test "Do not require user authentication on certain actions", %{conn: conn} do
    Enum.each([
      get(conn, article_path(conn, :index)),
      get(conn, article_path(conn, :show, "")),
    ], fn conn ->
      assert json_response(conn, 200)
    end)
  end

end
