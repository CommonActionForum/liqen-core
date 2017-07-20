defmodule Core.UserTest do
  use Core.ModelCase
  alias Core.Registration

  @super_user %{permissions: ["super_user"]}
  @valid_attrs %{email: "john@example.com", password: "1234"}

  test "converts unique_constraint on email to error" do
    insert_user(%{email: "matt@example.com"})
    attrs = Map.put(@valid_attrs, :email, "matt@example.com")

    assert {:error, _} = Registration.create_account(attrs)
  end
end
