defmodule Core.QuestionControllerTest do
  @moduledoc """
  Test for Core.QuestionController
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

  test "List of Questions", %{conn: conn}  do
    conn = conn
    |> get(question_path(conn, :index))

    assert json_response(conn, :ok)
  end

  test "Create a question", %{conn: conn} do
    conn1 = conn
    |> post(question_path(conn, :create), %{"title" => "x",
                                           "tags" => []})

    conn2 = conn
    |> post(question_path(conn, :create), %{"title" => ""})

    assert json_response(conn1, :created)
    assert json_response(conn2, :unprocessable_entity)
  end

  test "Show a question", %{conn: conn} do
    question = insert_question()

    conn = conn
    |> get(question_path(conn, :show, question.id))

    assert json_response(conn, :ok)
  end

  test "Update a question", %{conn: conn} do
    question = insert_question()

    conn1 = conn
    |> put(question_path(conn, :update, question.id), %{"title" => "b"})

    conn2 = conn
    |> put(question_path(conn, :update, question.id), %{"title" => ""})

    assert json_response(conn1, :ok)
    assert json_response(conn2, :unprocessable_entity)
  end

  test "Delete a question", %{conn: conn} do
    question = insert_question()

    conn = conn
    |> delete(question_path(conn, :delete, question.id))

    assert response(conn, :no_content)
  end

  test "Resource not found", %{conn: conn} do
    conn1 = get(conn, question_path(conn, :show, 0))
    conn2 = get(conn, question_path(conn, :update, 0, %{}))
    conn3 = get(conn, question_path(conn, :delete, 0))

    assert json_response(conn1, :not_found)
    assert json_response(conn2, :not_found)
    assert json_response(conn3, :not_found)
  end
end
