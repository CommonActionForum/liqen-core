defmodule Core.AnnotationTagControllerTest do
  use Core.ConnCase

  setup do
    # Create a super user
    user = insert_user(%{}, true)
    {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user)

    article = insert_article(%{})

    # Create an authored annotation
    annotation = insert_annotation(user, %{article_id: article.id})

    # Create a tag
    tag = insert_tag(%{})

    {:ok, %{annotation: annotation, jwt: jwt, article: article, tag: tag}}
  end

  test "Create correctly", %{annotation: annotation, jwt: jwt, tag: tag} do
    conn = build_conn()
    conn = conn
    |> put_req_header("authorization", "Bearer #{jwt}")
    |> post(annotation_annotation_tag_path(conn, :create, annotation.id), %{tag_id: tag.id})

    # Check response body
    assert json_response(conn, 201)
  end

  test "Create AnnotationTag: Tag not found", %{annotation: annotation, jwt: jwt, tag: tag} do
    conn = build_conn()
    conn = conn
    |> put_req_header("authorization", "Bearer #{jwt}")
    |> post(annotation_annotation_tag_path(conn, :create, annotation.id), %{tag_id: tag.id+1})

    assert json_response(conn, 422)
  end

  # TODO: Check delete /annotations/<A_ID>/tags/<T_ID>
  # When tag.id = <T_ID> doesn't exist
  test "Delete AnnotationTag: Tag not found", %{annotation: _, jwt: _, tag: _} do
    # Create the AnnotationTag using models...
    # Create the connection
    # assert response(conn, 404)
  end
end
