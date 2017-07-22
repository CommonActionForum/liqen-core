defmodule Core.Q do
  @moduledoc """
  Provides functions to get one, get all, create, update and delete:

  - Questions
  - Annotations
  - Liqens
  - Tags

  All similar functions has the same pattern (where XXX is question, annotation
  or liqen)

  - get_XXX(id)

    Gets an object. Returns {:ok, object} or {:error, :not_found}

  - get_all_XXX()

    Gets all objects. Returns {:ok, list}

  - create_XXX(author, params)

    Creates an object. Returns {:ok, object}, {:error, changeset} or
    {:error, :forbidden}

  - update_XXX(author, id, params)

    Updates an object. Returns {:ok, object}, {:error, :not_found},
    {:error, changeset} or {:error, :forbidden}

  - delete_XXX(author, id, params)

    Deletes an object. Returns {:ok, object}, {:error, :not_found},
    {:error, :forbidden} or {:error, :bad_request, reason}
  """

  use Core.Web, :model
  alias Core.Repo
  alias Core.Permissions
  alias Core.Accounts
  alias Core.Q.Tag
  alias Core.Q.Question

  def get_question(id) do
    id
    |> get(Question)
    |> set_question_author()
    |> take()
  end

  def get_annotation(id) do
  end

  def get_liqen(id) do
  end

  def get_tag(id) do
    id
    |> get(Tag)
    |> take()
  end

  def get_all_questions do
    questions = Repo.all(Question)
    |> Enum.map(fn question -> {:ok, question} end)
    |> Enum.map(&set_question_author/1)
    |> Enum.map(&take/1)
    |> Enum.map(fn {:ok, question} -> question end)

    {:ok, questions}
  end

  def get_all_annotations do
  end

  def get_all_liqens do
  end

  def get_all_tags do
    tags = Repo.all(Tag)
    |> Enum.map(fn question -> {:ok, question} end)
    |> Enum.map(&take/1)
    |> Enum.map(fn {:ok, question} -> question end)

    {:ok, tags}
  end

  def create_question(author, params) do
  end

  def create_annotation(author, params) do
  end

  def create_liqen(author, params) do
  end

  def create_tag(author, params) do
    with {:ok, _} <-
           Permissions.check_permissions(author, "create", "tags"),
         {:ok, changeset} <-
           create_tag_changeset(%Tag{}, params)
    do
      changeset
      |> Repo.insert()
      |> take()
    end
  end

  def update_question(author, id, params) do
  end

  def update_annotation(author, id, params) do
  end

  def update_liqen(author, id, params) do
  end

  def update_tag(author, id, params) do
    with {:ok, tag} <-
           get(id, Tag),
         {:ok, _} <-
           Permissions.check_permissions(author, "update", "tags", tag)
    do
      {:ok, changeset} = create_tag_changeset(tag, params)
      changeset
      |> Repo.update()
      |> take()
    end
  end

  def delete_question(author, id) do
  end

  def delete_annotation(author, id) do
  end

  def delete_liqen(author, id) do
  end

  def delete_tag(author, id) do
    with {:ok, tag} <-
           get(id, Tag),
         {:ok, _} <-
           Permissions.check_permissions(author, "delete", "tags", tag)
    do
      {:ok, changeset} = create_tag_changeset(tag, %{})
      case Repo.delete(changeset) do
        {:error, _}  ->
          {:error, :bad_request, "This tag is used in some questions and" <>
            " cannot be deleted. Use /questions?tagged=[#{id}] to check them"}
        {:ok, tag} ->
          take({:ok, tag})
      end
    end
  end

  defp create_tag_changeset(struct, params) do
    changeset =
      struct
      |> cast(params, [:title])
      |> validate_required([:title])
      |> foreign_key_constraint(
        :id,
        name: "questions_tags_tag_id_fkey"
      )

    case changeset do
      %{valid?: true} -> {:ok, changeset}
      _ -> {:error, changeset}
    end
  end

  defp get(id, struct) do
    case Repo.get(struct, id) do
      obj = %struct{} ->
        {:ok, obj}
      _ ->
        {:error, :not_found}
    end
  end

  defp take({:ok, %Tag{} = tag}) do
    {:ok, Map.take(tag, [:id, :title])}
  end

  defp take({:ok, %Question{} = question}) do
    {:ok, Map.take(question, [:id, :title, :author])}
  end
  defp take(any), do: any

  defp set_question_author({:ok, %Question{} = question}) do
    {:ok, author} = Accounts.get_user(question.author_id)
    {:ok, Map.put(question, :author, author)}
  end
  defp set_question_author(any), do: any
end
