defmodule Core.Tag do
  use Core.Web, :model

  schema "tags" do
    field :title, :string

    many_to_many :annotations, Core.Annotation, join_through: "annotations_tags"

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
