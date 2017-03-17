defmodule Core.FactAnnotationController do
  use Core.Web, :controller
  alias Core.FactAnnotation

  plug Guardian.Plug.EnsureAuthenticated, %{handler: Core.Auth}

  def create(conn, params) do
    changeset = FactAnnotation.changeset(%FactAnnotation{}, params)

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

  def delete(conn, %{"fact_id" => fact_id, "annotation_id" => annotation_id}) do
    fact = Repo.get_by!(FactAnnotation, %{fact_id: fact_id, annotation_id: annotation_id})

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(fact)

    send_resp(conn, :no_content, "")
  end
end
