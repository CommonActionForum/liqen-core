defmodule Core.QuestionTag do
  use Core.Web, :model

  schema "questions_tags" do
    belongs_to :question, Question, primary_key: true
    belongs_to :tag, Tag, primary_key: true
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:question_id, :tag_id])
    |> validate_required([:question_id, :tag_id])
    |> foreign_key_constraint(:question_id)
    |> foreign_key_constraint(:tag_id)
  end
end
