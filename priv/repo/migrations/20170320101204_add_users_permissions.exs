defmodule Core.Repo.Migrations.AddUsersPermissions do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :permissions, {:array, :string}, default: []
    end
  end
end
