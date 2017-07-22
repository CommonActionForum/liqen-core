defmodule Core.Repo.Migrations.AddQuestionsAuthor do
  use Ecto.Migration

  def change do
    alter table(:questions) do
      add :author_id, :integer
    end
  end
end
