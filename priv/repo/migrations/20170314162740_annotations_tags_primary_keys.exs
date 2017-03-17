defmodule Core.Repo.Migrations.AnnotationsTagsPrimaryKeys2 do
  use Ecto.Migration

  def change do
    drop table(:annotations_tags)

    create table(:annotations_tags) do
      add :tag_id, references(:tags), primary_key: true
      add :annotation_id, references(:annotations), primary_key: true
    end
  end
end
