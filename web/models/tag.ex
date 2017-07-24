defmodule Core.Tag do
  use Core.Web, :model

  schema "tags" do
    field :title, :string

    many_to_many :annotations, Core.Annotation, join_through: Core.AnnotationTag
    many_to_many :questions, Core.Question, join_through: Core.QuestionTag
    many_to_many :concepts, Core.Concept, join_through: Core.TagConcept

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title])
    |> validate_required([:title])
  end
end
