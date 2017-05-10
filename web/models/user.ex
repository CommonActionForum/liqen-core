defmodule Core.User do
  @moduledoc """
  A User represents a registered user.

  ## Fields

  Field              | Type                   |
  :----------------- | :--------------------- | :---------------------
  `email`            | `:string`              |
  `crypted_password` | `:string`              |
  `password`         | `:string`              | virtual
  `permissions`      | `{:array, :string}`    |
  `role`             | `:string`              | valid values: `"beta_user"`
  `author`           | `has_many` association | with `Core.Annotation`

  Not all fields are required for creating/updating Users. For example
  `crypted_password` which is generated from the given `password`. See
  `changeset/2` for details.

  ## Permissions

  Use this module to check if an user has permissions to perform an action.
  A permission is represented by `String`s with a concrete syntax.

  Depending of the syntax of a permission, that can be:

  - *Permission to edit/delete the resources created by the user*. The
    permissions have the syntax `{edit or delete}_{resource}`.

    For example `edit_annotations` allow users to edit annotations whose
    `author` is the user.

  - *Permission to edit/delete any resource*. The permissions have the syntax
    `{edit or delete}_all_{resource}`.

    For example `edit_all_annotations` allow users to edit any annotation.

  - *Permission to create a resource*. The permissions have the syntax
    `create_{resource}`.

    For example `create_annotations` allow users to create annotations.

  - *General permissions*. Permission that doesn't fit with any of the above.

  As a convention, the permission `"super_user"` allows the user to perform any
  action.

  ### Setting permissions

  A permission can only be set to a User via the `role` field of the changeset.
  Every allowed `role` is mapped with an array of permissions

  ### Checking permissions

  This module offers an API to check if a user has permissions to perform an
  action or not. The functions to check it are `can?/2`, `can?/3` and `can?/4`

  - Use `can?/4` to check permissions to edit, delete a specific resource of
    a certain type
  - Use `can?/3` to check permissions to edit, delete, create a resource of
    a certain type without specifying any object.
  - Use `can?/2` to check general permissions

  It is not recommended to use `can?/2` to check if a user has the
  `"super_user"` permission.
  """
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
  Builds a changeset to create a new user.

  Required parameters: `email`, `password`, `role`.

  If the changeset is valid, this function sets some `changes`:

  - A field called `crypted_password` with the cyphered `password`.
  - A field called `permissions` with the permissions of the user according
    to the `role`
  """
  def registration_changeset(struct, params \\ %{}) do
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
        changeset
        |> put_change(:crypted_password, Comeonin.Bcrypt.hashpwsalt(pass))

      _ ->
        changeset
    end
  end

  defp put_permissions(changeset) do
    # TODO - Refactor
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{role: role}} ->
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
          end
        put_change(changeset, :permissions, permissions)
      _ ->
        changeset
    end
  end

  @doc """
  Checks if a `user` has the `permission`
  """
  def can?(user, permission) do
    # TODO - Fix. Insert here the "super_user" check
    Enum.member?(user.permissions, permission)
  end

  @doc """
  Checks if a `user` has permissions to do an `action` to a resource given its
  `type` but without giving any specific object.
  """
  def can?(user, "create", type) do
    # TODO - Refactor. Call can?/2
    Enum.member?(user.permissions, "super_user") or
    Enum.member?(user.permissions, "create_#{type}")
  end

  def can?(user, action, type) do
    # TODO - Refactor. Call can?/2
    Enum.member?(user.permissions, "super_user") or
    Enum.member?(user.permissions, "#{action}_all_#{type}")
  end

  @doc """
  Checks if a `user` has permissions to do an `action` to a resource given its
  `type` and one specific object.
  """
  def can?(user, action, "users", object) do
    Enum.member?(user.permissions, "super_user") or
    Enum.member?(user.permissions, "#{action}_all_users") or (
      Enum.member?(user.permissions, "#{action}_users") and
      object.id === user.id
    )
  end

  def can?(user, action, type, object) do
    # TODO - Refactor. Call can?/3 and can?/2
    Enum.member?(user.permissions, "super_user") or
    Enum.member?(user.permissions, "#{action}_all_#{type}") or (
      Enum.member?(user.permissions, "#{action}_#{type}") and
      object.author === user.id
    )
  end
end
