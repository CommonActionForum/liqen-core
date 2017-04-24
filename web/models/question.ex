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
    |> validate_change(:answer, fn(:answer, tags) ->
      tags
      |> Enum.map(&validate_tag/1)
      |> Enum.filter(fn tag -> tag != :ok end)
    end)
  end

  defp validate_tag(%{tag: tag, required: required}) do
    :ok
  end
  defp validate_tag(_) do
    {:tags, {"Missing fields: tag and required, %{index}", [index: 1]}}
  end
end
