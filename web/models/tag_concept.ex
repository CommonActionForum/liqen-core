defmodule Core.TagConcept do
  use Core.Web, :model

  schema "tags_concepts" do
    belongs_to :tag, Core.Tag, primary_key: true
    belongs_to :concept, Core.Concept, primary_key: true

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:tag_id, :concept_id])
    |> validate_required([:tag_id, :concept_id])
    |> foreign_key_constraint(:tag_id)
    |> foreign_key_constraint(:concept_id)
  end
end
