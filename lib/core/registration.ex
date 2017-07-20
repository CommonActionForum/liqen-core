defmodule Core.Registration do
  @moduledoc """
  Operations of creating new users
  """
  use Core.Web, :model

  alias Core.Repo
  alias Core.Accounts.User

  @doc """
  Creates an account based on email, password and role
  """
  def create_account(attrs \\ %{}) do
    %User{}
    |> create_user_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates an account based on email and password with the role "beta_user"
  """
  def create_beta_account(attrs \\ %{}) do
    attrs = Map.put(attrs, :role, "beta_user")

    %User{}
    |> create_user_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Builds a changeset to create a new user, based on email, password and role
  """
  def create_user_changeset(struct, params \\ %{}) do
    valid_roles = [
      "beta_user",
      "root"
    ]

    struct
    |> cast(params, [:email, :password, :role])
    |> validate_required([:email, :password, :role])
    |> validate_inclusion(:role, valid_roles)
    |> put_pass_hash()
    |> Core.Permissions.put_permissions()
  end

  @doc """
  Try to authenticate an user
  """
  def login_user(email, pass) do
    user = Repo.get_by(User, email: email)

    cond do
      user && Comeonin.Bcrypt.checkpw(pass, user.crypted_password) ->
        {:ok, user}
      true ->
        :error
    end
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
end
