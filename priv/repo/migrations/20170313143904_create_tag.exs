defmodule Core.Repo.Migrations.CreateTag do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :title, :string
      add :href, :string

      timestamps()
    end

  end
end
