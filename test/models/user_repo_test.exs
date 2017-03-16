defmodule Core.UserRepoTest do
  use Core.ModelCase
  alias Core.User

  @valid_attrs %{email: "john@example.com", password: "1234"}

  test "converts unique_constraint on email to error" do
    insert_user(%{email: "matt@example.com"})
    attrs = Map.put(@valid_attrs, :email, "matt@example.com")
    changeset = User.changeset(%User{}, attrs)

    assert {:error, _} = Repo.insert(changeset)
  end
end
