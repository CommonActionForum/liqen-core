defmodule Core.Article do
  use Core.Web, :model

  schema "articles" do
    field :title, :string
    field :body, Core.ArticleBody
    has_many :annotations, Core.Annotation

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :body])
    |> validate_required([:title, :body])
  end
end
