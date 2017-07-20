defmodule Core.Permissions do
  @moduledoc """
  Operations with users permissions
  """
  use Core.Web, :model

  @doc """
  Put permissions to a changeset
  """
  def put_permissions(changeset = %Ecto.Changeset{valid?: true,
                                                  changes: %{role: role}}) do
    permissions =
      case role do
        "root" -> ["super_user"]
        "beta_user" -> [
          "show_users",
          "create_facts",
          "read_facts",
          "update_facts",
          "delete_facts",
          "create_annotations",
          "read_annotations",
          "update_annotations",
          "delete_annotations",
        ]
        _ -> []
      end

    put_change(changeset, :permissions, permissions)
  end
  def put_permissions(changeset), do: changeset

  @doc """
  Check if a `user` has permissions to do an `action` to a resource of a `type`
  """
  def check_permissions(user, action, type) do
    case can?(user, action, type) do
      true -> {:ok, user}
      nil -> {:error, :forbidden}
    end
  end

  @doc """
  Check if a `user` has a `permission`

  Generally instead of using this, use `can?/3` and `can?/4`
  """
  def can?(user, permission) do
    Enum.member?(user.permissions, "super_user") or
    Enum.member?(user.permissions, permission)
  end

  @doc """
  Checks if a `user` has permissions to do an `action` to a resource of a `type`
  """
  def can?(user, "create", type) do
    can?(user, "create_#{type}")
  end
  def can?(user, action, type) do
    can?(user, "#{action}_all_#{type}")
  end

  @doc """
  Checks if a `user` has permissions to do an `action` to a `resource` of a
  `type`
  """
  def can?(user, action, "users", object) do
    can?(user, action, "users") or (
      can?(user, "#{action}_users") and object.id === user.id
    )
  end
  def can?(user, "create", type, object) do
    false
  end
  def can?(user, action, type, object) do
    can?(user, action, type) or (
      can?(user, "#{action}_#{type}") and object.author === user.id
    )
  end
end
