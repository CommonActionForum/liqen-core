defmodule Core.Q.Question do
  @moduledoc """
  Defines a Question
  """
  use Ecto.Schema

  schema "questions" do
    field :author, :map, virtual: true
    field :author_id, :integer
    field :title, :string
    field :required_tags, {:array, :integer}, virtual: true
    field :optional_tags, {:array, :integer}, virtual: true

    timestamps()
  end
end
