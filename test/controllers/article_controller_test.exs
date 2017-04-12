defmodule Core.ArticleControllerTest do
  @moduledoc """
  Test for Core.ArticleController
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

  test "List of Articles", %{conn: conn} do
    conn = conn
    |> get(article_path(conn, :index))

    assert json_response(conn, :ok)
  end

  test "Create an article", %{conn: conn} do
    conn1 = conn
    |> post(article_path(conn, :create, %{}))

    params = %{"title" => "x",
               "source_uri" => "x",
               "source_target" => %{"type" => "XPathSelector",
                                    "value" => "x"}}

    conn2 = conn
    |> post(article_path(conn, :create, params))

    assert json_response(conn1, :unprocessable_entity)
    assert json_response(conn2, :created)
  end

  test "Show an article", %{conn: conn} do
    article = insert_article()

    conn = conn
    |> get(article_path(conn, :show, article.id))

    assert json_response(conn, :ok)
  end

  test "Update an article", %{conn: conn} do
    article = insert_article()

    conn1 = conn
    |> put(article_path(conn, :update, article.id, %{"title" => ""}))

    conn2 = conn
    |> put(article_path(conn, :update, article.id, %{}))

    assert json_response(conn1, :unprocessable_entity)
    assert json_response(conn2, :ok)
  end

  test "Delete an article", %{conn: conn} do
    article = insert_article()

    conn = conn
    |> delete(article_path(conn, :delete, article.id))

    assert response(conn, :no_content)
  end

  test "Resource not found", %{conn: conn} do
    conn1 = get(conn, article_path(conn, :show, 0))
    conn2 = get(conn, article_path(conn, :update, 0, %{}))
    conn3 = get(conn, article_path(conn, :delete, 0))

    assert json_response(conn1, :not_found)
    assert json_response(conn2, :not_found)
    assert json_response(conn3, :not_found)
  end
end
