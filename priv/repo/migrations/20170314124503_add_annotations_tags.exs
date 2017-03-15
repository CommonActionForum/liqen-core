defmodule Core.Repo.Migrations.AddAnnotationsTags do
  use Ecto.Migration

  def change do
    create table(:annotations_tags, primary_key: false) do
      add :annotation_id, references(:annotations)
      add :tag_id, references(:tags)
    end
  end
end
