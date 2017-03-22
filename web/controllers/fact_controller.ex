defmodule Core.FactController do
  use Core.Web, :controller
  alias Core.Fact

  plug Guardian.Plug.EnsureAuthenticated, %{handler: Core.Auth} when action in [:create, :update, :delete]
  plug :find when action in [:update, :delete, :show]

  def index(conn, _params) do
    facts = Repo.all(Fact)
    |> Repo.preload(:question)

    render(conn, "index.json", facts: facts)
  end

  def create(conn, fact_params) do
    changeset = Fact.changeset(%Fact{}, fact_params)

    case Repo.insert(changeset) do
      {:ok, fact} ->
        fact = fact
        |> Repo.preload(:question)
        |> Repo.preload(:annotations)

        conn
        |> put_status(:created)
        |> put_resp_header("location", fact_path(conn, :show, fact))
        |> render("show.json", fact: fact)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Core.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, _) do
    fact = conn.assigns[:fact]
    |> Repo.preload(:question)
    |> Repo.preload(:annotations)

    render(conn, "show.json", fact: fact)
  end

  def update(conn, fact_params) do
    fact = conn.assigns[:fact]
    changeset = Fact.changeset(fact, fact_params)

    case Repo.update(changeset) do
      {:ok, fact} ->
        fact = fact
        |> Repo.preload(:question)
        |> Repo.preload(:annotations)

        render(conn, "show.json", fact: fact)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Core.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, _) do
    fact = conn.assigns[:fact]

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(fact)

    send_resp(conn, :no_content, "")
  end

  defp find(conn = %Plug.Conn{params: %{"id" => id}}, _opts) do
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
