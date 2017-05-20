defmodule Core.Web.FactController do
  use Core.Web, :controller
  alias Core.Fact
  alias Core.FactAnnotation

  plug :find when action in [:update, :delete, :show]
  plug Core.Auth, %{key: :fact,
                    type: "facts"} when action in [:create, :update, :delete]

  def index(conn, _params) do
    facts =
      Fact
      |> Repo.all()
      |> Repo.preload(:question)

    render(conn, "index.json", facts: facts)
  end

  def create(conn, fact_params) do
    changeset = Fact.changeset(%Fact{}, fact_params)

    case insert_fact_and_annotations(changeset) do
      {:ok, fact} ->
        fact =
          fact
          |> Repo.preload(:question)
          |> Repo.preload(:fact_annotations)

        conn
        |> put_status(:created)
        |> put_resp_header("location", fact_path(conn, :show, fact))
        |> render("show.json", fact: fact)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Core.Web.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, _) do
    fact =
      conn.assigns.fact
      |> Repo.preload(:question)
      |> Repo.preload(:fact_annotations)

    render(conn, "show.json", fact: fact)
  end

  def update(conn, fact_params) do
    fact =
      conn.assigns.fact
      |> Repo.preload(:fact_annotations)

    fact = Map.merge(fact, %{annotations: fact.fact_annotations })

    changeset = Fact.changeset(fact, fact_params)

    case update_fact_and_annotations(changeset) do
      {:ok, fact} ->
        fact =
          fact
          |> Repo.preload(:question)
          |> Repo.preload(:fact_annotations)

        render(conn, "show.json", fact: fact)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Core.Web.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, _) do
    fact = conn.assigns.fact

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
        |> render(Core.Web.ErrorView, "404.json", %{})
        |> halt()

      fact ->
        conn
        |> assign(:fact, fact)
    end
  end

  defp insert_fact_and_annotations(changeset) do
    Repo.transaction(fn ->
      result =
        changeset
        |> Repo.insert()
        |> insert_annotations(changeset)

      case result do
        {:error, changeset} ->
          Repo.rollback(changeset)

        {:ok, fact, _annotations} ->
          fact
      end
    end)
  end

  defp update_fact_and_annotations(changeset) do
    Repo.transaction(fn ->
      result =
        changeset
        |> Repo.update()
        |> remove_annotations(changeset)
        |> insert_annotations(changeset)

      case result do
        {:error, changeset} ->
          Repo.rollback(changeset)

        {:ok, fact, _annotations} ->
          fact
      end
    end)
  end

  defp insert_annotations({:error, changeset}, _), do: {:error, changeset}
  defp insert_annotations({:ok, fact}, changeset) do
    changeset
    |> Ecto.Changeset.get_field(:annotations)
    |> Enum.map(create_changeset(fact.id))
    |> Enum.reduce({:ok, fact, []}, &insert_annotation/2)
  end

  defp remove_annotations({:error, changeset}, _), do: {:error, changeset}
  defp remove_annotations({:ok, fact}, _) do
    query = from(fa in FactAnnotation, where: fa.fact_id == ^fact.id)

    Repo.delete_all(query)
    {:ok, fact}
  end

  defp create_changeset(fact_id), do: fn annotation_id ->
    params = %{"annotation_id" => annotation_id,
               "fact_id" => fact_id}

    FactAnnotation.changeset(%FactAnnotation{}, params)
  end

  defp insert_annotation(_, {:error, changeset}) do
    {:error, changeset}
  end
  defp insert_annotation(changeset = %{valid?: valid}, {:ok, fact, annotations})
  when valid do
    case Repo.insert(changeset) do
      {:ok, annotation} ->
        {:ok, fact, [annotation | annotations]}

      {:error, changeset} ->
        {:error, changeset}
    end
  end
  defp insert_annotation(changeset, _), do: {:error, changeset}
end
