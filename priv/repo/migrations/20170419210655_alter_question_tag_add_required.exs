defmodule Core.Repo.Migrations.AlterQuestionTagAddRequired do
  use Ecto.Migration

  def change do
    alter table(:questions_tags) do
      add :required, :boolean
    end
  end
end
