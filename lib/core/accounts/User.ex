defmodule Core.Accounts.User do
  use Ecto.Schema

  schema "users" do
    field :email, :string
    field :crypted_password, :string
    field :password, :string, virtual: true
    field :name
    field :permissions, {:array, :string}
    field :role, :string, virtual: true
    has_many :annotations, Core.Annotation, foreign_key: :author

    timestamps()
  end
end
