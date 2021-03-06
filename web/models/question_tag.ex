defmodule Core.QuestionTag do
  use Core.Web, :model

  schema "questions_tags" do
    belongs_to :question, Core.Question, primary_key: true
    belongs_to :tag, Core.Tag, primary_key: true

    field :required, :boolean
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:question_id, :tag_id, :required])
    |> validate_required([:question_id, :tag_id, :required])
    |> foreign_key_constraint(:question_id)
    |> foreign_key_constraint(:tag_id)
  end
end
