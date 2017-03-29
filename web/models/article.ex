defmodule Core.Article do
  use Core.Web, :model

  schema "articles" do
    field :title, :string
    field :body, Core.ArticleBody
    field :source_uri, :string
    field :source_target, Core.Target
    has_many :annotations, Core.Annotation

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :body, :source_uri, :source_target])
    |> validate_required([:title, :source_uri, :source_target])
  end
end
