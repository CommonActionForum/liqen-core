defmodule Core.FactAnnotationController do
  use Core.Web, :controller
  alias Core.FactAnnotation
  alias Core.Fact

  plug :find
  plug Core.Auth, %{key: :fact, type: "facts"}

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

  def delete(conn, %{"id" => annotation_id}) do
    fact = conn.assigns[:fact]
    annotation = Repo.get_by!(FactAnnotation, %{fact_id: fact.id, annotation_id: annotation_id})

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(annotation)

    send_resp(conn, :no_content, "")
  end

  defp find(conn = %Plug.Conn{params: %{"fact_id" => id}}, _opts) do
    case Repo.get(Fact, id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> render(Core.ErrorView, "404.json", %{})
        |> halt()

      fact ->
        conn
        |> assign(:fact, fact)
    end
  end
end
