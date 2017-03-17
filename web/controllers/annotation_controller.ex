defmodule Core.AnnotationController do
  use Core.Web, :controller
  alias Core.Annotation

  plug Guardian.Plug.EnsureAuthenticated, %{handler: Core.Auth} when action in [:create, :update, :delete]
  plug Core.BodyParams, name: "annotation"
  plug :find when action in [:update, :delete, :show]

  def index(conn, _params) do
    annotations = Repo.all(Annotation)
    render(conn, "index.json", annotations: annotations)
  end

  def create(conn, %{"annotation" => annotation_params}) do
    user = Guardian.Plug.current_resource(conn)
    changeset = user
    |> build_assoc(:annotations)
    |> Annotation.changeset(annotation_params)

    case Repo.insert(changeset) do
      {:ok, annotation} ->
        annotation = Repo.preload(annotation, :annotation_tags)

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

  def show(conn, %{"id" => _}) do
    annotation = conn.assigns[:annotation]
    |> Repo.preload(:annotation_tags)

    conn
    |> render("show.json", annotation: annotation)
  end

  def update(conn, %{"id" => _, "annotation" => annotation_params}) do
    annotation = conn.assigns[:annotation]
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

  def delete(conn, %{"id" => _}) do
    annotation = conn.assigns[:annotation]

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(annotation)

    send_resp(conn, :no_content, "")
  end

  defp find(conn = %Plug.Conn{params: %{"id" => id}}, _opts) do
    case Repo.get(Annotation, id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> render(Core.ErrorView, "404.json", %{})
        |> halt()

      annotation ->
        conn
        |> assign(:annotation, annotation)
    end
  end
end
