defmodule Core.Repo.Migrations.CreateConcepts do
  use Ecto.Migration

  def change do
    create table(:concepts) do
      add :name, :string
      add :uri, :string

      timestamps()
    end

    create table(:tags_concepts) do
      add :tag_id, references(:tags)
      add :concept_id, references(:concepts)

      timestamps()
    end

    alter table(:annotations) do
      add :concept_id, references(:concepts)
    end
  end
end
