defmodule Core.ArticleControllerTest do
  use Core.ConnCase

  setup do
    # Create a super user
    user = insert_user(%{}, true)

    {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user)

    # Create an article
    article = insert_article(%{})

    {:ok, %{jwt: jwt, article: article}}
  end

  test "Create correctly", %{jwt: jwt} do
    params = %{
      "title" => "a",
      "body" => "b"
    }

    conn = build_conn()
    conn = conn
    |> put_req_header("authorization", "Bearer #{jwt}")
    |> post(article_path(conn, :create), params)

    # Check response body
    article = json_response(conn, 201)
    assert article

    # Check "location" header
    assert(article_path(conn, :show, article["id"])
      in get_resp_header(conn, "location"))
  end

  test "Find the proper article", %{article: article} do
    conn = build_conn()
    conn = get(conn, article_path(conn, :show, article.id))

    assert json_response(conn, 200)
  end

  test "Access to update properly", %{article: article, jwt: jwt} do
    conn = build_conn()
    conn = conn
    |> put_req_header("authorization", "Bearer #{jwt}")
    |> put(article_path(conn, :update, article.id, %{}))

    assert json_response(conn, 200)
  end

  test "Access to delete properly", %{article: article, jwt: jwt} do
    conn = build_conn()
    conn = conn
    |> put_req_header("authorization", "Bearer #{jwt}")
    |> delete(article_path(conn, :delete, article.id))

    assert response(conn, 204)
  end
end
