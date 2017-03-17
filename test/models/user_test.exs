defmodule Core.UserTest do
  use Core.ModelCase, async: true

  alias Core.User

  @valid_attrs %{email: "john@example.com", password: "secret"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changeset with valid attributes hashes password" do
    attrs = Map.put(@valid_attrs, :password, "12345")
    changeset = User.changeset(%User{}, attrs)
    %{password: p, crypted_password: cp} = changeset.changes

    assert changeset.valid?
    assert cp
    assert Comeonin.Bcrypt.checkpw(p, cp)
  end
end
