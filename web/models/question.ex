defmodule Core.Question do
  use Core.Web, :model

  schema "questions" do
    field :title, :string
    many_to_many :question_tags, Core.Tag, join_through: Core.QuestionTag

    field :answer, {:array, :map}, virtual: true

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :answer])
    |> validate_required([:title, :answer])
  end
end
