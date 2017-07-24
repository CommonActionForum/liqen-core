defmodule Core.ConceptController do
  use Core.Web, :controller
  alias Core.Concept

  plug :find when action in [:update, :delete, :show]
  plug Core.Auth, %{key: :concept, type: "concepts"}
  when action in [:create, :update, :delete]

  def index(conn, _params) do
    concepts = Repo.all(Concept)
    render(conn, "index.json", concepts: concepts)
  end

  def create(conn, concept_params) do
    changeset = Concept.changeset(%Concept{}, concept_params)

    case Repo.insert(changeset) do
      {:ok, concept} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", concept_path(conn, :show, concept))
        |> render("show.json", concept: concept)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Core.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, _) do
    concept = conn.assigns.concept
    render(conn, "show.json", concept: concept)
  end

  def update(conn, concept_params) do
    concept = conn.assigns.concept
    changeset = Concept.changeset(concept, concept_params)

    case Repo.update(changeset) do
      {:ok, concept} ->
        render(conn, "show.json", concept: concept)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Core.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, _) do
    concept = conn.assigns.concept

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(concept)

    send_resp(conn, :no_content, "")
  end

  defp find(conn = %Plug.Conn{params: %{"id" => id}}, _opts) do
    case Repo.get(Concept, id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> render(Core.ErrorView, "404.json", %{})
        |> halt()

      concept ->
        conn
        |> assign(:concept, concept)
    end
  end
end
