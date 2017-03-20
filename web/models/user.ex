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
            "root" -> ["super_root"]
            "beta_user" -> [
              "create_facts",
              "read_authored_facts",
              "update_authored_facts",
              "delete_authored_facts",
              "create_annotations",
              "read_authored_annotations",
              "update_authored_annotations",
              "delete_authored_annotations",
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
end
