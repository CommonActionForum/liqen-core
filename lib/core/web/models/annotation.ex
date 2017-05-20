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

    field :tags, {:array, :integer}, virtual: true

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
    |> cast(params, [:article_id, :target, :tags])
    |> validate_required([:article_id, :target, :tags])
    |> foreign_key_constraint(:article_id)
  end

  @doc """
  Builds a query based on the parameters.

  ## Parameters

  - `article_id`. Filter annotations by article (article ID).
  - `author`. Filter annotations by author (user ID)
  """
  def query(params) do
    query = from a in __MODULE__, select: a

    query = case Map.fetch(params, "article_id") do
              :error -> query
              {:ok, article_id} ->
                from a in query, where: a.article_id == ^article_id
            end

    query = case Map.fetch(params, "author") do
              :error -> query
              {:ok, author} ->
                from a in query, where: a.author == ^author
            end

    query
  end
end
