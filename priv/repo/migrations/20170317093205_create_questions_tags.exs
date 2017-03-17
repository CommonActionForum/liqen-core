defmodule Core.Repo.Migrations.CreateQuestionsTags do
  use Ecto.Migration

  def change do
    create table(:questions_tags) do
      add :question_id, references(:annotations)
      add :tag_id, references(:tags)
    end
  end
end
