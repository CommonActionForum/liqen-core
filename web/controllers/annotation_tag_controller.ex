defmodule Core.AnnotationTagController do
  use Core.Web, :controller
  alias Core.AnnotationTag
  alias Core.Annotation

  plug :find
  plug Core.Auth, %{key: :annotation, type: "annotations"}

  def create(conn, params) do
    changeset = AnnotationTag.changeset(%AnnotationTag{}, params)

    case Repo.insert(changeset) do
      {:ok, _annotation_tag} ->
        conn
        |> put_status(:created)
        |> render(Core.CodeView, "201.json", %{})
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Core.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"annotation_id" => annotation_id, "tag_id" => tag_id}) do
    tag = Repo.get_by!(AnnotationTag, %{annotation_id: annotation_id, tag_id: tag_id})

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(tag)

    send_resp(conn, :no_content, "")
  end

  # Finds an annotation with "id"=`id`
  #
  # Assigns that annotation to the `conn` object
  defp find(conn = %Plug.Conn{params: %{"annotation_id" => id}}, _opts) do
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
