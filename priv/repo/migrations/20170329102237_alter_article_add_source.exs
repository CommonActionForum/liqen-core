defmodule Core.Repo.Migrations.AlterArticleAddSource do
  use Ecto.Migration

  def change do
    alter table(:articles) do
      add :source_uri, :string
      add :source_target, :map
    end
  end
end
