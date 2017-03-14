defmodule Core.AnnotationTag do
  use Core.Web, :model

  schema "annotations_tags" do
    belongs_to :annotation, Annotation, primary_key: true
    belongs_to :tag, Tag, primary_key: true
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:annotation_id, :tag_id])
    |> validate_required([:annotation_id, :tag_id])
    |> foreign_key_constraint(:annotation_id)
    |> foreign_key_constraint(:tag_id)

  end
end
