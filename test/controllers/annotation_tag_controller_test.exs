defmodule Core.AnnotationTagControllerTest do
  @moduledoc """
  Test for Core.AnnotationTagController
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

  test "Create a Tag inside a Annotation", %{conn: conn, user: user} do
    article = insert_article()
    annotation = insert_annotation(user, %{article_id: article.id})
    tag = insert_tag()

    params = %{"tag_id" => tag.id}

    conn1 = conn
    |> post(annotation_annotation_tag_path(conn, :create, annotation.id), params)

    conn2 = conn
    |> post(annotation_annotation_tag_path(conn, :create, annotation.id), %{"tag_id" => 0})

    assert json_response(conn1, :created)
    assert json_response(conn2, :unprocessable_entity)
  end

  test "Delete a Tag inside a Annotation", %{conn: conn, user: user} do
    article = insert_article()
    annotation = insert_annotation(user, %{article_id: article.id})
    tag = insert_tag()
    insert_annotation_tag(%{annotation_id: annotation.id,
                          tag_id: tag.id})

    conn = conn
    |> delete(annotation_annotation_tag_path(conn, :delete, annotation.id, tag.id))

    assert response(conn, :no_content)
  end

  test "Resource not found", %{conn: conn} do
    conn1 = post(conn, annotation_annotation_tag_path(conn, :create, 0), %{})
    conn2 = delete(conn, annotation_annotation_tag_path(conn, :delete, 0, 0))

    assert json_response(conn1, :not_found)
    assert json_response(conn2, :not_found)
  end
end
