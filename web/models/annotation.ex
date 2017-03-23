defmodule Core.Annotation do
  @moduledoc """
  An Annotation represents a fragment of an article with tags.

  ## Fields

  - `target`. The fragment of the article
  - `article`. The article
  - `author`. Author of the annotation
  - `annotation_tags`. Tags of the annotation
  """
  use Core.Web, :model

  schema "annotations" do
    field :target, Core.Target

    belongs_to :article, Core.Article
    belongs_to :user, Core.User, foreign_key: :author

    many_to_many :annotation_tags, Core.Tag, join_through: Core.AnnotationTag

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.

  ## Params

  - `article_id`. ID of the article that has the annotation
  - `target`. Fragment of the article that has the annotation

  This function only returns a valid changeset if:

  - Both params are provided

  The returned changeset also checks (when manipulating the storage) that
  `article_id` corresponds to an article.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:article_id, :target])
    |> validate_required([:article_id, :target])
    |> foreign_key_constraint(:article_id)
  end
end
