defmodule Core.AnnotationControllerTest do
  use Core.ConnCase

  alias Core.Annotation
  @valid_attrs %{}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, annotation_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    annotation = Repo.insert! %Annotation{}
    conn = get conn, annotation_path(conn, :show, annotation)
    assert json_response(conn, 200)["data"] == %{"id" => annotation.id,
      "article_id" => annotation.article_id,
      "author" => annotation.author}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, annotation_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, annotation_path(conn, :create), annotation: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Annotation, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, annotation_path(conn, :create), annotation: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    annotation = Repo.insert! %Annotation{}
    conn = put conn, annotation_path(conn, :update, annotation), annotation: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Annotation, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    annotation = Repo.insert! %Annotation{}
    conn = put conn, annotation_path(conn, :update, annotation), annotation: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    annotation = Repo.insert! %Annotation{}
    conn = delete conn, annotation_path(conn, :delete, annotation)
    assert response(conn, 204)
    refute Repo.get(Annotation, annotation.id)
  end
end
