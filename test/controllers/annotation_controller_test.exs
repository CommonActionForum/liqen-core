defmodule Core.AnnotationControllerTest do
  use Core.ConnCase

  setup do
    # Create a super user
    user = insert_user(%{})
    |> Map.put(:permissions, ["super_user"])

    article = insert_article(%{})

    # Create an authored annotation
    annotation = insert_annotation(user, %{article_id: article.id})


    {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user)

    {:ok, %{annotation: annotation, jwt: jwt}}
  end

  test "Find the proper annotation", %{annotation: annotation} do
    conn = build_conn()
    conn = get(conn, annotation_path(conn, :show, annotation.id))

    assert json_response(conn, 200)
  end

  test "Access to update properly", %{annotation: annotation, jwt: jwt} do
    conn = build_conn()
    conn = conn
    |> put_req_header("authorization", "Bearer #{jwt}")
    |> put(annotation_path(conn, :update, annotation.id, %{}))

    assert json_response(conn, 200)
  end
end
