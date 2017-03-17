defmodule Core.QuestionView do
  use Core.Web, :view

  def render("index.json", %{questions: questions}) do
    render_many(questions, Core.QuestionView, "summary.json")
  end

  def render("show.json", %{question: question}) do
    render_one(question, Core.QuestionView, "question.json")
  end

  def render("summary.json", %{question: question}) do
    %{id: question.id,
      title: question.title}
  end

  def render("question.json", %{question: question}) do
    %{id: question.id,
      title: question.title,
      tags: question.question_tags}
  end
end
