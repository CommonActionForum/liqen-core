defmodule Core.ArticleView do
  use Core.Web, :view

  def render("index.json", %{articles: articles}) do
    render_many(articles, Core.ArticleView, "summary.json")
  end

  def render("show.json", %{article: article}) do
    render_one(article, Core.ArticleView, "article.json")
  end

  def render("summary.json", %{article: article}) do
    %{id: article.id,
      title: article.title}
  end

  def render("article.json", %{article: article}) do
    %{id: article.id,
      title: article.title,
      body: article.body}
  end
end
