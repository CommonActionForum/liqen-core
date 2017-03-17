defmodule Core.Fact do
  use Core.Web, :model

  schema "facts" do
    belongs_to :question, Core.Question
    many_to_many :annotations, Core.Annotation, join_through: Core.FactAnnotation

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:question_id])
    |> validate_required([:question_id])
    |> foreign_key_constraint(:question_id)
  end
end
