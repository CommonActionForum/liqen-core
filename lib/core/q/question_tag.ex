defmodule Core.Q.QuestionTag do
  use Core.Web, :model

  schema "questions_tags" do
    field :question_id, :integer
    field :tag_id, :integer
    field :required, :boolean
  end
end
