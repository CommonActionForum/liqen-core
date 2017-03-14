defmodule Core.Annotation do
  use Core.Web, :model

  schema "annotations" do
    field :target, Core.Target

    belongs_to :article, Core.Article
    belongs_to :user, Core.User, foreign_key: :author

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:article_id, :target])
    |> validate_required([:article_id, :target])
    |> foreign_key_constraint(:article_id)
  end
end
