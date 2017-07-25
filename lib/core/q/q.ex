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
  alias Core.Q.QuestionTag

  def get_question(id) do
    id
    |> get(Question)
    |> set_question_author()
    |> set_question_tags()
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
    Question
    |> get_all()
    |> Enum.map(&set_question_author/1)
    |> take(summary: true)
  end

  def get_all_annotations do
  end

  def get_all_liqens do
  end

  def get_all_tags do
    Tag
    |> get_all()
    |> take()
  end

  def create_question(author, params) do
    with {:ok, _} <-
           Permissions.check_permissions(author, "create", "question"),
         {:ok, changeset} <-
           question_changeset(
             %Question{},
             Map.put(params, :author_id, author.id)
           )
    do
      changeset
      |> Repo.insert()
      |> set_question_author()
      |> take()
    end
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

  defp question_changeset(struct, params) do
    not_included_in = fn (list) ->
      fn (item) ->
        case Enum.find(params[list], nil, fn (x) -> x == item end) do
          nil -> true
          _ -> "The tag #{item} cannot be included in both lists"
        end
      end
    end

    changeset =
      struct
      |> cast(params, [:title, :author_id, :required_tags, :optional_tags])
      |> validate_required([:title, :author_id, :required_tags, :optional_tags])
      |> validate_list(:required_tags, not_included_in.(:optional_tags))
      |> validate_list(:optional_tags, not_included_in.(:required_tags))

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

  defp get_all(struct) do
    struct
    |> Repo.all()
    |> Enum.map(fn obj -> {:ok, obj} end)
  end

  defp take(object, options \\ [summary: false])
  defp take(list, options) when is_list(list) do
    list =
      list
      |> Enum.map(&take(&1, options))
      # We are assuming that every object in "list" is now a {:ok, obj} tuple
      |> Enum.map(fn {:ok, obj} -> obj end)

    {:ok, list}
  end

  defp take({:ok, %Tag{} = tag}, _) do
    {:ok, Map.take(tag, [:id, :title])}
  end

  defp take({:ok, %Question{} = question}, options) do
    fields =
      case Keyword.get(options, :summary) do
        true ->
          [:id, :title, :author]
        false ->
          [:id, :title, :author, :required_tags, :optional_tags]
      end

    {:ok, Map.take(question, fields)}
  end
  defp take(any, _), do: any

  defp set_question_author({:ok, %Question{} = question}) do
    {:ok, author} = Accounts.get_user(question.author_id)
    {:ok, Map.put(question, :author, author)}
  end
  defp set_question_author(any), do: any

  defp set_question_tags({:ok, %Question{} = question}) do
    query = from t in QuestionTag, where: t.question_id == ^question.id
    tags =
      query
      |> Repo.all()
      |> Repo.preload(:tag)
      |> Enum.map(fn qt -> %{required: qt.required, tag: qt.tag} end)

    {:ok, required_tags} =
      tags
      |> Enum.filter(fn qt -> qt.required end)
      |> Enum.map(fn qt -> {:ok, qt.tag} end)
      |> take()

    {:ok, optional_tags} =
      tags
      |> Enum.filter(fn qt -> !qt.required end)
      |> Enum.map(fn qt -> {:ok, qt.tag} end)
      |> take()

    question_with_tags =
      question
      |> Map.put(:required_tags, required_tags)
      |> Map.put(:optional_tags, optional_tags)

    {:ok, question_with_tags}
  end
  defp set_question_tags(any), do: any

  # validator is a function that receives values
  # and returns true or a string with an error
  defp validate_list(changeset, field, validator) do
    %{changes: changes, errors: errors} = changeset
    ensure_field_exists!(changeset, field)

    list = Map.get(changes, field)
    indexed_list = Enum.zip(0..Enum.count(list), list)
    new_errors =
      indexed_list
      |> Enum.map(fn({index, element}) -> {index, validator.(element)} end)
      |> Enum.filter(fn({index, string}) -> string != true end)
      |> Enum.map(fn({index, string}) -> {"#{field}[#{index}]", {string, []}} end)

    case new_errors do
      [] -> changeset
      _ -> %{changeset | errors: new_errors ++ errors, valid?: false}
    end
  end

  # Mimmics Ecto.Changeset.ensure_field_exists!
  defp ensure_field_exists!(%Ecto.Changeset{types: types, data: data}, field) do
    unless Map.has_key?(types, field) do
      raise ArgumentError, "unknown field #{inspect field} for changeset on #{inspect data}"
    end
    true
  end
end
