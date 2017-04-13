defmodule Core.FactAnnotationControllerTest do
  @moduledoc """
  Test for Core.FactAnnotationController
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

  test "Create an Annotation inside a Fact", %{conn: conn, user: user} do
    article = insert_article()
    annotation = insert_annotation(user, %{article_id: article.id})
    question = insert_question()
    fact = insert_fact(%{question_id: question.id})

    params = %{"fact_id" => fact.id,
               "annotation_id" => annotation.id}

    conn1 = conn
    |> post(fact_fact_annotation_path(conn, :create, fact.id), params)

    conn2 = conn
    |> post(fact_fact_annotation_path(conn, :create, fact.id), %{"annotation_id" => 0})

    assert json_response(conn1, :created)
    assert json_response(conn2, :unprocessable_entity)
  end

  test "Delete an Annotation inside a Fact", %{conn: conn, user: user} do
    article = insert_article()
    annotation = insert_annotation(user, %{article_id: article.id})
    question = insert_question()
    fact = insert_fact(%{question_id: question.id})
    insert_fact_annotation(%{fact_id: fact.id,
                             annotation_id: annotation.id})

    conn = conn
    |> delete(fact_fact_annotation_path(conn, :delete, fact.id, annotation.id))

    assert response(conn, :no_content)
  end

  test "Resource not found", %{conn: conn} do
    conn1 = post(conn, fact_fact_annotation_path(conn, :create, 0), %{})
    conn2 = delete(conn, fact_fact_annotation_path(conn, :delete, 0, 0))

    assert json_response(conn1, :not_found)
    assert json_response(conn2, :not_found)
  end
end
