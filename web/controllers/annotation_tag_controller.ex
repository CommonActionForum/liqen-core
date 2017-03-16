defmodule Core.AnnotationTagController do
  use Core.Web, :controller
  alias Core.AnnotationTag

  plug Guardian.Plug.EnsureAuthenticated, %{handler: Core.Auth}

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
end
