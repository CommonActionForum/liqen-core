defmodule Core.Repo.Migrations.CreateAnnotation do
  use Ecto.Migration

  def change do
    create table(:annotations) do
      add :article_id, references(:articles, on_delete: :nothing)
      add :author, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:annotations, [:article_id])
    create index(:annotations, [:author])

  end
end
