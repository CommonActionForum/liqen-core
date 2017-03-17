defmodule Core.Repo.Migrations.CreateQuestion do
  use Ecto.Migration

  def change do
    create table(:questions) do
      add :title, :string

      timestamps()
    end

  end
end
