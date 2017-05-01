defmodule Core.AnnotationControllerTest do
  @moduledoc """
  Test for Core.AnnotationController
  """
  use Core.ConnCase

  setup do
    user = insert_user(%{}, true)
    {:ok, jwt, _} = Guardian.encode_and_sign(user)

    conn =
      build_conn()
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "Bearer #{jwt}")

    {:ok, %{conn: conn, user: user}}
  end

  test "List of 0 Annotations", %{conn: conn} do
    conn
    |> get(annotation_path(conn, :index))
    |> json_response(:ok)
    |> check_array_view("annotation.json")
    |> assert()
  end

  test "List of 1 Annotation", %{conn: conn, user: user} do
    article = insert_article()
    annotation = insert_annotation(user, %{article_id: article.id})

    conn
    |> get(annotation_path(conn, :index))
    |> json_response(:ok)
    |> check_array_view("annotation.json")
    |> assert()
  end

  test "Create an annotation", %{conn: conn} do
    article = insert_article()
    tag = insert_tag(%{})

    valid_params1 = %{"title" => "x",
                      "article_id" => article.id,
                      "target" => %{"type" => "XPathSelector",
                                    "value" => "x"},
                      "tags" => []}

    valid_params2 = %{"title" => "x",
                      "article_id" => article.id,
                      "target" => %{"type" => "XPathSelector",
                                    "value" => "x"},
                      "tags" => [tag.id]}

    invalid_params1 = %{"title" => ""}


    conn
    |> post(annotation_path(conn, :create), valid_params1)
    |> json_response(:created)
    |> check_view("annotation.json")
    |> assert()

    conn
    |> post(annotation_path(conn, :create), valid_params2)
    |> json_response(:created)
    |> check_view("annotation.json")
    |> assert()

    conn
    |> post(annotation_path(conn, :create), invalid_params1)
    |> json_response(:unprocessable_entity)
    |> check_view("error.json")
    |> assert()
  end

  test "Show an annotation", %{conn: conn, user: user} do
    article = insert_article()
    annotation = insert_annotation(user, %{article_id: article.id})

    conn
    |> get(annotation_path(conn, :show, annotation.id))
    |> json_response(:ok)
    |> check_view("annotation.json")
    |> assert()
  end

  test "Update an annotation", %{conn: conn, user: user} do
    article = insert_article()
    annotation = insert_annotation(user, %{article_id: article.id})

    valid_params1 = %{}
    invalid_params1 = %{"target" => ""}

    conn
    |> put(annotation_path(conn, :update, annotation.id, valid_params1))
    |> json_response(:ok)
    |> check_view("annotation.json")
    |> assert()

    conn
    |> put(annotation_path(conn, :update, annotation.id, invalid_params1))
    |> json_response(:unprocessable_entity)
    |> check_view("error.json")
    |> assert()
  end

  test "Delete an annotation", %{conn: conn, user: user} do
    article = insert_article()
    annotation = insert_annotation(user, %{article_id: article.id})

    conn
    |> delete(annotation_path(conn, :delete, annotation.id))
    |> response(:no_content)
    |> assert()
  end

  test "Resource not found", %{conn: conn} do
    conn
    |> get(annotation_path(conn, :show, 0))
    |> json_response(:not_found)
    |> assert()

    conn
    |> put(annotation_path(conn, :update, 0, %{}))
    |> json_response(:not_found)
    |> assert()

    conn
    |> delete(annotation_path(conn, :delete, 0))
    |> json_response(:not_found)
    |> assert()
  end
end
