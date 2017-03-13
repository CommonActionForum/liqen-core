defmodule Core.UserTest do
  use Core.ModelCase

  alias Core.User

  @valid_attrs %{password: "some password", email: "aaa@aaa.aa"}

  test "User creation with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "User creation with no attributes" do
    invalid_attrs = %{}
    changeset = User.changeset(%User{}, invalid_attrs)
    refute changeset.valid?
  end

  test "User creation with no password" do
    invalid_attrs = %{email: "aaa@aa.aa"}
    changeset = User.changeset(%User{}, invalid_attrs)
    refute changeset.valid?
  end

  test "User creation with no email" do
    invalid_attrs = %{password: "12345"}
    changeset = User.changeset(%User{}, invalid_attrs)
    refute changeset.valid?
  end
end
