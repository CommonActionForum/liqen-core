defmodule Core.Repo.Migrations.CreateFacts do
  use Ecto.Migration

  def change do
    create table(:facts) do
      add :question_id, references(:questions, on_delete: :nothing)

      timestamps()
    end
  end
end
