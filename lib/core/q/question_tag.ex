defmodule Core.Q.QuestionTag do
  use Core.Web, :model

  schema "questions_tags" do
    field :required, :boolean

    belongs_to :question, Core.Q.Question
    belongs_to :tag, Core.Q.Tag
  end
end
