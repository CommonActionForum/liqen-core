defmodule Core.Article do
  @moduledoc """
  An Article represents a text article.

  ## Fields

  - `title`. The title of the article
  - `body`. The body of the article
  - `annotations`. Author of the annotation
  """
  use Core.Web, :model

  schema "articles" do
    field :title, :string
    field :body, :string
    has_many :annotations, Core.Annotation

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.

  ## Params

  - `title`
  - `body`

  This function returns a valid changeset if:

  - Both params are provided
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :body])
    |> validate_required([:title, :body])
  end
end
