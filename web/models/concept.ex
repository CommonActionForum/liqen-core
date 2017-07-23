defmodule Core.Concept do
  use Core.Web, :model

  schema "concepts" do
    field :name, :string
    field :uri, :string

    has_many :annotation, Core.Annotation
    many_to_many :tags, Core.Tag, join_through: Core.TagConcept

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :uri])
    |> validate_required([:name, :uri])
  end
end
