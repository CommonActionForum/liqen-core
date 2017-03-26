defmodule Core.AnnotationController do
  @moduledoc """
  Implements a Phoenix Controller for handling the calls of the API resource
  `annotation`

  See `Phoenix.Controller`
  """
  use Core.Web, :controller
  alias Core.Annotation

  plug :find when action in [:update, :delete, :show]
  plug Core.Auth, %{key: :annotation,
                    type: "annotations"} when action in [:create, :update, :delete]

  @doc """
  Renders a list of all the annotations
  """
  def index(conn, _params) do
    annotations = Repo.all(Annotation)
    render(conn, "index.json", annotations: annotations)
  end

  @doc """
  Creates an annotation

  Valid `annotation_params` are the same as the specified in
  `Core.Annotation.changeset/2`
  """
  def create(conn, annotation_params) do
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

  @doc """
  Renders an annotation

  `conn.assigns.annotation` must be the Annotation object to show.
  """
  def show(conn, _) do
    annotation = conn.assigns[:annotation]
    |> Repo.preload(:annotation_tags)

    conn
    |> render("show.json", annotation: annotation)
  end

  @doc """
  Updates an annotation

  Valid `annotation_params` are the same as the specified in
  `Core.Annotation.changeset/2`

  `conn.assigns.annotation` must be the Annotation object to edit.
  """
  def update(conn, annotation_params) do
    annotation = conn.assigns[:annotation]
    changeset = Annotation.changeset(annotation, annotation_params)

    case Repo.update(changeset) do
      {:ok, annotation} ->
        annotation = Repo.preload(annotation, :annotation_tags)
        conn
        |> render("show.json", annotation: annotation)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Core.ChangesetView, "error.json", changeset: changeset)
    end
  end

  @doc """
  Deletes an annotation

  `conn.assigns.annotation` must be the Annotation object to delete.
  """
  def delete(conn, _) do
    annotation = conn.assigns[:annotation]
    Repo.delete!(annotation)
    send_resp(conn, :no_content, "")
  end

  # This plug finds an annotation whose `id` is the param "id" of the request.
  # - If found, sets that to `conn.assigns.annotation`
  # - If not, halts and respond with a 404 not found error
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
