defmodule Core.QuestionController do
  use Core.Web, :controller
  alias Core.Question
  alias Core.QuestionTag

  plug :find when action in [:update, :delete, :show]
  plug Core.Auth, %{key: :question,
                    type: "questions"} when action in [:create, :update, :delete]

  def index(conn, _params) do
    questions = Repo.all(Question)
    render(conn, "index.json", questions: questions)
  end

  def create(conn, question_params) do
    changeset = Question.changeset(%Question{}, question_params)

    case insert_question_and_tags(changeset) do
      {:ok, question} ->
        answer = Repo.all(from(qt in QuestionTag, where: qt.question_id == ^question.id))
        question = Map.merge(question, %{answer: answer})

        conn
        |> put_status(:created)
        |> put_resp_header("location", question_path(conn, :show, question))
        |> render("show.json", %{question: question})

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Core.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, _) do
    question = conn.assigns[:question]
    answer = Repo.all(from(qt in QuestionTag, where: qt.question_id == ^question.id))
    question = Map.merge(question, %{answer: answer})

    render(conn, "show.json", %{question: question})
  end

  def update(conn, question_params) do
    question = conn.assigns[:question]
    |> Repo.preload(:question_tags)

    changeset = Question.changeset(
      Map.merge(question, %{answer: question.question_tags}),
      question_params)

    case update_question_and_tags(changeset) do
      {:ok, question} ->
        answer = Repo.all(from(qt in QuestionTag, where: qt.question_id == ^question.id))
        question = Map.merge(question, %{answer: answer})

        render(conn, "show.json", %{question: question})
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Core.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, _) do
    question = conn.assigns[:question]

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(question)

    send_resp(conn, :no_content, "")
  end

  defp find(conn = %Plug.Conn{params: %{"id" => id}}, _opts) do
    case Repo.get(Question, id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> render(Core.ErrorView, "404.json", %{})
        |> halt()
      question ->
        conn
        |> assign(:question, question)
    end
  end

  defp insert_question_and_tags(changeset) do
    Repo.transaction(fn ->
      case (Repo.insert(changeset) |> insert_tags(changeset)) do
        {:error, changeset} ->
          Repo.rollback(changeset)
        {:ok, question, tags} ->
          Map.merge(question, %{tags: tags})
      end
    end)
  end

  defp update_question_and_tags(changeset) do
    Repo.transaction(fn ->
      case (Repo.update(changeset) |> remove_tags(changeset) |> insert_tags(changeset)) do
        {:error, changeset} ->
          Repo.rollback(changeset)
        {:ok, question, tags} ->
          Map.merge(question, %{tags: tags})
      end
    end)
  end

  defp insert_tags({:error, changeset}, _), do: {:error, changeset}
  defp insert_tags({:ok, question}, changeset) do
    tag_id_to_changeset = fn answer ->
      QuestionTag.changeset(%QuestionTag{}, %{"tag_id" => answer["tag"],
                                              "required" => answer["required"],
                                              "question_id" => question.id})
    end

    insert_changeset = fn
      (_changeset, {:error, x}) ->
        {:error, x}

      (changeset = %{valid?: valid}, {:ok, _question, _tags}) when not valid ->
        {:error, changeset}

      (changeset, {:ok, question, tags}) ->
        case Repo.insert(changeset) do
          {:ok, tag} ->
            {:ok, question, [tag|tags]}

          {:error, changeset} ->
            {:error, changeset}
        end
    end

    Enum.map(Ecto.Changeset.get_field(changeset, :answer), tag_id_to_changeset)
    |> Enum.reduce({:ok, question, []}, insert_changeset)
  end

  defp remove_tags({:error, changeset}, _), do: {:error, changeset}
  defp remove_tags({:ok, question}, _) do
    query = from(qt in QuestionTag, where: qt.question_id == ^question.id)
    Repo.delete_all(query)

    {:ok, question}
  end
end
