defmodule Core.AnnotationController do
  use Core.Web, :controller

  alias Core.Annotation

  def index(conn, _params) do
    annotations = Repo.all(Annotation)
    render(conn, "index.json", annotations: annotations)
  end

  def create(conn, %{"annotation" => annotation_params}) do
    changeset = Annotation.changeset(%Annotation{}, annotation_params)

    case Repo.insert(changeset) do
      {:ok, annotation} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", annotation_path(conn, :show, annotation))
        |> render("show.json", annotation: annotation)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Core.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    annotation = Repo.get!(Annotation, id)
    render(conn, "show.json", annotation: annotation)
  end

  def update(conn, %{"id" => id, "annotation" => annotation_params}) do
    annotation = Repo.get!(Annotation, id)
    changeset = Annotation.changeset(annotation, annotation_params)

    case Repo.update(changeset) do
      {:ok, annotation} ->
        render(conn, "show.json", annotation: annotation)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Core.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    annotation = Repo.get!(Annotation, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(annotation)

    send_resp(conn, :no_content, "")
  end
end
