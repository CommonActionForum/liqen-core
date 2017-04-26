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
    answer = Enum.map(question.answer, fn tag ->
      %{tag: tag.id}
    end)

    %{id: question.id,
      title: question.title,
      answer: answer}
  end
end
