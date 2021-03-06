defmodule Core.FactView do
  use Core.Web, :view

  def render("index.json", %{facts: facts}) do
    render_many(facts, Core.FactView, "summary.json")
  end

  def render("show.json", %{fact: fact}) do
    render_one(fact, Core.FactView, "fact.json")
  end

  def render("summary.json", %{fact: fact}) do
    %{id: fact.id,
      question_id: fact.question.id}
  end

  def render("fact.json", %{fact: fact}) do
    annotations = Enum.map(fact.fact_annotations, fn(annotation) ->
      %{id: annotation.id,
        article_id: annotation.article_id,
        target: annotation.target}
    end)

    %{id: fact.id,
      question_id: fact.question.id,
      annotations: annotations}
  end
end
