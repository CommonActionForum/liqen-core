defmodule Core.AnnotationTag do
  @moduledoc """
  An AnnotationTag represents the many-to-many relationship between
  `Core.Annotation` and `Core.Tag`.

  ## Fields

  Field        | Type         |
  :----------- | :----------- | :----------------
  `annotation` | `belongs_to` | `Core.Annotation`
  `tag`        | `belongs_to` | `Core.Tag`
  """
  use Core.Web, :model

  schema "annotations_tags" do
    belongs_to :annotation, Core.Annotation, primary_key: true
    belongs_to :tag, Core.Tag, primary_key: true
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.

  Required parameters: `annotation_id`, `tag_id`.

  The returned changeset also checks (when manipulating the storage) that both
  `annotation_id` and `tag_id` corresponds to a annotation and tag.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:annotation_id, :tag_id])
    |> validate_required([:annotation_id, :tag_id])
    |> foreign_key_constraint(:annotation_id)
    |> foreign_key_constraint(:tag_id)
  end
end
