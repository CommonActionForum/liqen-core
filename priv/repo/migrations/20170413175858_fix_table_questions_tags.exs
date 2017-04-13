defmodule Core.Repo.Migrations.FixTableQuestionsTags do
  use Ecto.Migration

  def change do
    alter table(:questions_tags) do
      remove :question_id
      add :question_id, references(:questions)
    end
  end
end
