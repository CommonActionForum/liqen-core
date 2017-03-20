defmodule Core.User do
  use Core.Web, :model

  schema "users" do
    field :email, :string
    field :crypted_password, :string
    field :password, :string, virtual: true
    field :permissions, {:array, :string}
    field :role, :string, virtual: true
    has_many :annotations, Core.Annotation, foreign_key: :author

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :password, :role])
    |> validate_required([:email, :password, :role])
    |> validate_inclusion(:role, ["beta_user"])
    |> unique_constraint(:email)
    |> put_pass_hash()
    |> put_permissions()
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :crypted_password, Comeonin.Bcrypt.hashpwsalt(pass))

      _ ->
        changeset
    end
  end

  defp put_permissions(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{role: role}} ->
        permissions =
          case role do
            "root" -> ["super_user"]
            "beta_user" -> [
              "create_facts",
              "read_facts",
              "update_facts",
              "delete_facts",
              "create_annotations",
              "read_annotations",
              "update_annotations",
              "delete_annotations",
            ]
          end
        put_change(changeset, :permissions, permissions)
      _ ->
        changeset
    end
  end

  def can?(user, permission) do
    Enum.member?(user.permissions, permission)
  end

  def can?(user, "create", type) do
    Enum.member?(user.permissions, "super_user") or
    Enum.member?(user.permissions, "create_#{type}")
  end

  def can?(user, action, type, object) do
    Enum.member?(user.permissions, "super_user") or
    Enum.member?(user.permissions, "#{action}_all_#{type}") or (
      Enum.member?(user.permissions, "#{action}_#{type}") and
      object.author === user.id
    )
  end
end
