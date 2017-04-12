defmodule Core.AnnotationControllerTest do
  @moduledoc """
  Test for Core.AnnotationController
  """
  use Core.ConnCase

  setup do
    user = insert_user(%{}, true)
    {:ok, jwt, _} = Guardian.encode_and_sign(user)

    conn = build_conn()
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", "Bearer #{jwt}")

    {:ok, %{conn: conn, user: user}}
  end

  test "List of Annotations", %{conn: conn} do
    conn = conn
    |> get(annotation_path(conn, :index))

    assert json_response(conn, :ok)
  end

  test "Create an annotation", %{conn: conn} do
    article = insert_article()

    conn1 = conn
    |> post(annotation_path(conn, :create, %{}))

    params = %{"article_id" => article.id,
               "target" => %{"type" => "XPathSelector",
                             "value" => "x"}}

    conn2 = conn
    |> post(annotation_path(conn, :create, params))

    assert json_response(conn1, :unprocessable_entity)
    assert json_response(conn2, :created)
  end

  test "Show an annotation", %{conn: conn, user: user} do
    article = insert_article()
    annotation = insert_annotation(user, %{article_id: article.id})

    conn = conn
    |> get(annotation_path(conn, :show, annotation.id))

    assert json_response(conn, :ok)
  end

  test "Update an annotation", %{conn: conn, user: user} do
    article = insert_article()
    annotation = insert_annotation(user, %{article_id: article.id})

    conn1 = conn
    |> put(annotation_path(conn, :update, annotation.id, %{"target" => ""}))

    conn2 = conn
    |> put(annotation_path(conn, :update, annotation.id, %{}))

    assert json_response(conn1, :unprocessable_entity)
    assert json_response(conn2, :ok)
  end

  test "Delete an annotation", %{conn: conn, user: user} do
    article = insert_article()
    annotation = insert_annotation(user, %{article_id: article.id})

    conn = conn
    |> delete(annotation_path(conn, :delete, annotation.id))

    assert response(conn, :no_content)
  end

  test "Resource not found", %{conn: conn} do
    conn1 = get(conn, annotation_path(conn, :show, 0))
    conn2 = get(conn, annotation_path(conn, :update, 0, %{}))
    conn3 = get(conn, annotation_path(conn, :delete, 0))

    assert json_response(conn1, :not_found)
    assert json_response(conn2, :not_found)
    assert json_response(conn3, :not_found)
  end
end
