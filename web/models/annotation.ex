defmodule Core.Annotation do
  @moduledoc """
  An Annotation represents a fragment of an article with tags.

  ## Fields

  Field             | Type           |
  :---------------- | :------------- | :---------------------
  `target`          | `Core.Target`  |
  `article`         | `belongs_to`   | `Core.Article`
  `user`            | `belongs_to`   | `Core.User`
  `annotation_tags` | `many_to_many` | `Core.Tag` through `Core.AnnotationTag`

  Not all fields are required for creating/updating Annotations. See
  `changeset/2` for details.
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

  ## Parameterss

  Required parameters: `article_id`, `target`.

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
