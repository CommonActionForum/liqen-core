defmodule Core.Article do
  @moduledoc """
  An Article represents a text article.

  ## Fields

  Field          | Type                   |
  :------------- | :--------------------- | :---------------------
  `title`        | `:string`              |
  `body`         | `:string`              |
  `annotations`  | `has_many` association | with `Core.Annotation`
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

  ## Parameters

  Required parameters: `title`, `body`
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :body])
    |> validate_required([:title, :body])
  end
end
