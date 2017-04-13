defmodule Core.FactControllerTest do
  @moduledoc """
  Test for Core.FactController
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

  test "List of Facts", %{conn: conn}  do
    conn = conn
    |> get(fact_path(conn, :index))

    assert json_response(conn, :ok)
  end

  test "Create a fact", %{conn: conn} do
    question = insert_question()

    conn1 = conn
    |> post(fact_path(conn, :create, %{}))

    conn2 = conn
    |> post(fact_path(conn, :create, %{"question_id" => question.id}))

    assert json_response(conn1, :unprocessable_entity)
    assert json_response(conn2, :created)
  end

  test "Show a fact", %{conn: conn} do
    question = insert_question()
    fact = insert_fact(%{question_id: question.id})

    conn = conn
    |> get(fact_path(conn, :show, fact.id))

    assert json_response(conn, :ok)
  end

  test "Update a fact", %{conn: conn} do
    question = insert_question()
    fact = insert_fact(%{question_id: question.id})

    conn1 = conn
    |> put(fact_path(conn, :update, fact.id, %{"question_id" => 0}))

    conn2 = conn
    |> put(fact_path(conn, :update, fact.id, %{}))

    assert json_response(conn1, :unprocessable_entity)
    assert json_response(conn2, :ok)
  end

  test "Delete a fact", %{conn: conn} do
    question = insert_question()
    fact = insert_fact(%{question_id: question.id})

    conn = conn
    |> delete(fact_path(conn, :delete, fact.id))

    assert response(conn, :no_content)
  end

  test "Resource not found", %{conn: conn} do
    conn1 = get(conn, fact_path(conn, :show, 0))
    conn2 = get(conn, fact_path(conn, :update, 0, %{}))
    conn3 = get(conn, fact_path(conn, :delete, 0))

    assert json_response(conn1, :not_found)
    assert json_response(conn2, :not_found)
    assert json_response(conn3, :not_found)
  end
end
