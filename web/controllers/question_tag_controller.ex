defmodule Core.QuestionTagController do
  use Core.Web, :controller
  alias Core.QuestionTag
  alias Core.Question

  plug :find
  plug Core.Auth, %{key: :question, type: "questions"}

  def create(conn, %{"tag_id" => tag_id}) do
    question = conn.assigns[:question]
    changeset = QuestionTag.changeset(%QuestionTag{}, %{"question_id" => question.id,
                                                        "tag_id" => tag_id})

    case Repo.insert(changeset) do
      {:ok, _question_tag} ->
        conn
        |> put_status(:created)
        |> render(Core.CodeView, "201.json", %{})
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Core.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => tag_id}) do
    question = conn.assigns[:question]
    tag = Repo.get_by!(QuestionTag, %{question_id: question.id, tag_id: tag_id})

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(tag)

    send_resp(conn, :no_content, "")
  end

  # Finds an annotation with "id"=`id`
  #
  # Assigns that annotation to the `conn` object
  defp find(conn = %Plug.Conn{params: %{"question_id" => id}}, _opts) do
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
end
