defmodule Core.Web.ArticleView do
  use Core.Web, :view

  def render("index.json", %{articles: articles}) do
    render_many(articles, Core.Web.ArticleView, "summary.json")
  end

  def render("show.json", %{article: article}) do
    render_one(article, Core.Web.ArticleView, "article.json")
  end

  def render("summary.json", %{article: article}) do
    %{id: article.id,
      title: article.title,
      source: %{uri: article.source_uri}}
  end

  def render("article.json", %{article: article}) do
    %{id: article.id,
      title: article.title,
      source: %{uri: article.source_uri,
                target: article.source_target}}
  end
end
