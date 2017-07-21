defmodule Core.Q.Question do
  @moduledoc """
  Defines a Question
  """
  use Ecto.Schema

  schema "questions" do
    field :author, {:array, :map}, virtual: true
    field :title, :string
    field :required_tags, {:array, :map}, virtual: true
    field :optional_tags, {:array, :map}, virtual: true

    timestamps()
  end
end
