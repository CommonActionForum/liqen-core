defmodule Core.FactAnnotation do
  use Core.Web, :model

  schema "facts_annotations" do
    belongs_to :fact, Core.Fact, primary_key: true
    belongs_to :annotation, Core.Annotation, primary_key: true
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:fact_id, :annotation_id])
    |> validate_required([:fact_id, :annotation_id])
    |> foreign_key_constraint(:fact_id)
    |> foreign_key_constraint(:annotation_id)
  end
end
