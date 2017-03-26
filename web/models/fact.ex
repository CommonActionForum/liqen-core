defmodule Core.Fact do
  @moduledoc """
  A Fact is a collection of annotations that answers a question.

  ## Fields

  Field         | Type           |
  :------------ | :------------- | :---------------------
  `question`    | `belongs_to`   | `Core.Question`
  `annotations` | `many_to_many` | `Core.Tag` through `Core.AnnotationTag`
  """
  use Core.Web, :model

  schema "facts" do
    belongs_to :question, Core.Question
    many_to_many :annotations, Core.Annotation, join_through: Core.FactAnnotation

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.

  ## Parameters

  Required parameters: `question_id`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:question_id])
    |> validate_required([:question_id])
    |> foreign_key_constraint(:question_id)
  end
end
