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
    many_to_many :fact_annotations, Core.Annotation,
      join_through: Core.FactAnnotation

    field :annotations, {:array, :integer}, virtual: true

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.

  ## Parameters

  Required parameters: `question_id`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:question_id, :annotations])
    |> validate_required([:question_id, :annotations])
    |> foreign_key_constraint(:question_id)
  end

  @doc """
  Check if a fact answers a question completely
  """
  def answers?(fact, question) do
    available = fact.annotations
    |> Enum.map(fn annotation -> annotation.tags end)
    |> List.flatten()

    question.answer
    |> Enum.filter(fn tag -> tag.required end)
    |> Enum.map(fn item -> item.tag.id end)
    |> Enum.all?(&Enum.member?(available, &1))
  end
end
