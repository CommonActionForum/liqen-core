defmodule Core.Repo.Migrations.AddTargetToAnnotations do
  use Ecto.Migration

  def change do
    alter table(:annotations) do
      add :target, :map
    end
  end
end
