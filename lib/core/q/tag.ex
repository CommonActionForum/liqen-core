defmodule Core.Q.Tag do
  @moduledoc """
  Defines a Tag
  """
  use Ecto.Schema

  schema "tags" do
    field :title, :string

    timestamps()
  end
end
