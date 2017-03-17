defmodule Core.Repo.Migrations.CreateFactsAnnotations do
  use Ecto.Migration

  def change do
    create table (:facts_annotations) do
      add :fact_id, references(:facts)
      add :annotation_id, references(:annotations)
    end
  end
end
