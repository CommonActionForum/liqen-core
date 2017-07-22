defmodule Core.Repo.Migrations.AddUsersName do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :name, :string
    end
  end
end
