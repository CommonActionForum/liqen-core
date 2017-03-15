defmodule Core.QuestionView do
  use Core.Web, :view

  def render("index.json", %{questions: questions}) do
    %{data: render_many(questions, Core.QuestionView, "question.json")}
  end

  def render("show.json", %{question: question}) do
    %{data: render_one(question, Core.QuestionView, "question.json")}
  end

  def render("question.json", %{question: question}) do
    %{id: question.id,
      title: question.title,
      tags: question.tags}
  end
end
