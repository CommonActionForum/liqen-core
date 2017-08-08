defmodule Core.CMS.Entry do
  @moduledoc """
  An Entry is a registered and stored "content" piece. Entry only stores
  references to the original content, not the content itself.

  ## Fields

  - **title**. Descriptive name of the content. This name is only for
    description purposes. The content itself can have other information that
    overrides this title.

  - **is_link**. True means that the stored reference is an external content.
    In that case, the uri of the content must be present in **link**.

  - **link**. External uri of the content. Only valid if **is_link** is true.
    Must be blank if **is_link** is false.

  - **author**. Reference to the person who create the entry (not necessarily
    the content itself)
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Core.CMS.Entry

  schema "entries" do
    field :title, :string
    field :is_link, :boolean
    field :link, :string

    timestamps()
  end

  @doc false
  def changeset(%Entry{} = entry, attrs) do
    entry
    |> cast(attrs, [:title, :is_link, :link])
    |> validate_required([:title, :is_link])
    |> validate_link
  end

  defp validate_link(%Ecto.Changeset{} = changeset) do
    is_link = get_change(changeset, :is_link)

    if is_link do
      validate_required(
        changeset,
        :link,
        message: "Can't be blank if \"is_link\" is set to true"
      )
    else
      delete_change(changeset, :link)
    end
  end
end
