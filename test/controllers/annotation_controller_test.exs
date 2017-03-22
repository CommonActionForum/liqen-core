defmodule Core.AnnotationControllerTest do
  use Core.ConnCase

  setup do
    # Create a super user
    user = insert_user(%{}, true)

    article = insert_article(%{})

    # Create an authored annotation
    annotation = insert_annotation(user, %{article_id: article.id})


    {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user)

    {:ok, %{annotation: annotation, jwt: jwt, article: article}}
  end

  test "Create correctly", %{article: article, jwt: jwt} do
    params = %{
      "article_id" => article.id,
      "target" => %{
        "type" => "FragmentSelector",
        "value" => "",
        "refinedBy" => %{
          "type" => "TextQuoteSelector",
          "prefix" => "",
          "exact" => "",
          "suffix" => ""
        }
      }
    }

    conn = build_conn()
    conn = conn
    |> put_req_header("authorization", "Bearer #{jwt}")
    |> post(annotation_path(conn, :create), params)

    # Check response body
    annotation = json_response(conn, 201)
    assert annotation

    # Check "location" header
    assert(annotation_path(conn, :show, annotation["id"])
      in get_resp_header(conn, "location"))
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

  test "Access to delete properly", %{annotation: annotation, jwt: jwt} do
    conn = build_conn()
    conn = conn
    |> put_req_header("authorization", "Bearer #{jwt}")
    |> delete(annotation_path(conn, :delete, annotation.id))

    assert response(conn, 204)
  end
end
