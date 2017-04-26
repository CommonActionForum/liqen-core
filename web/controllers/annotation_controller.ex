defmodule Core.AnnotationController do
  @moduledoc """
  Implements a Phoenix Controller for handling the calls of the API resource
  `annotation`

  See `Phoenix.Controller`
  """
  use Core.Web, :controller
  alias Core.Annotation
  alias Core.AnnotationTag

  plug :find when action in [:update, :delete, :show]
  plug Core.Auth, %{key: :annotation,
                    type: "annotations"} when action in [:create, :update, :delete]

  @doc """
  Renders a list of all the annotations
  """
  def index(conn, params) do
    query = Annotation.query(params)
    annotations = Repo.all(query)

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

    case insert_annotation_and_tags(changeset) do
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
    |> Repo.preload(:annotation_tags)

    annotation = Map.merge(annotation, %{tags: annotation.annotation_tags})
    changeset = Annotation.changeset(annotation, annotation_params)

    case update_annotation_and_tags(changeset) do
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

  # Insert annotation and tags
  defp insert_annotation_and_tags(changeset) do
    tags = Ecto.Changeset.get_field(changeset, :tags)

    Repo.transaction(fn ->
      result = Repo.insert(changeset)
      |> add_tags(tags)

      case result do
        {:error, changeset} ->
          Repo.rollback(changeset)

        {:ok, annotation, tags} ->
          Map.merge(annotation, %{tags: tags})
      end
    end)
  end

  # Update annotation and tags
  defp update_annotation_and_tags(changeset) do
    tags = Ecto.Changeset.get_field(changeset, :tags)

    Repo.transaction(fn ->
      result = Repo.update(changeset)
      |> remove_tags()
      |> add_tags(tags)

      case result do
        {:error, changeset} ->
          Repo.rollback(changeset)

        {:ok, annotation, tags} ->
          Map.merge(annotation, %{tags: tags})
      end
    end)
  end

  # Add tags to an annotation
  #
  # Returns a {:ok, tags} or {:error, changeset} tuple
  defp add_tags({:error, changeset}, _), do: {:error, changeset}
  defp add_tags({:ok, annotation}, tags) do
    tags
    |> Enum.map(fn tag ->
      AnnotationTag.changeset(%AnnotationTag{}, %{tag_id: tag,
                                                  annotation_id: annotation.id})
    end)
    |> Enum.reduce({:ok, annotation, []}, &add_tag/2)
  end

  # Add a tag into a annotation
  defp add_tag(_, {:error, changeset}), do: {:error, changeset}
  defp add_tag(changeset = %{valid?: valid}, {:ok, _, _}) when not valid do
    {:error, changeset}
  end
  defp add_tag(changeset, {:ok, annotation, tags}) do
    case Repo.insert(changeset) do
      {:ok, tag} ->
        {:ok, annotation, [tag|tags]}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  # Remove all tags from a annotation
  defp remove_tags({:error, changeset}), do: {:error, changeset}
  defp remove_tags({:ok, annotation}) do
    query =  from(qt in AnnotationTag, where: qt.annotation_id == ^annotation.id)
    Repo.delete_all(query)

    {:ok, annotation}
  end
end
