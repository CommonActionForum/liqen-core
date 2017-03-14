defmodule Core.Annotation do
  use Core.Web, :model

  schema "annotations" do
    belongs_to :article, Core.Article
    belongs_to :user, Core.User, foreign_key: :author

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:article_id])
    |> validate_required([:article_id])
    |> foreign_key_constraint(:article_id)
  end
end
