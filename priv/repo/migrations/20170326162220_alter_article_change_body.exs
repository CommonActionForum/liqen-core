defmodule Core.Repo.Migrations.AlterArticleChangeBody do
  use Ecto.Migration

  def change do
    alter table(:articles) do
      remove :body
      add :body, {:array, :map}
    end
  end
end
