defmodule Core.UserTest do
  use Core.ModelCase
  alias Core.User

  @super_user %{permissions: ["super_user"]}
  @valid_attrs %{email: "john@example.com", password: "1234"}

  test "converts unique_constraint on email to error" do
    insert_user(%{email: "matt@example.com"})
    attrs = Map.put(@valid_attrs, :email, "matt@example.com")
    changeset = User.changeset(%User{}, attrs)

    assert {:error, _} = Repo.insert(changeset)
  end

  test "can?/2 with valid permissions" do
    user = %{permissions: ["perm1"]}

    assert User.can?(user, "perm1")
  end

  test "can?/3 with create_ permissions" do
    yes = %{permissions: ["create_articles"]}
    no = %{permissions: ["create_all_articles"]}

    assert User.can?(@super_user, "create", "articles")
    assert User.can?(yes, "create", "articles")
    refute User.can?(no, "create", "articles")
  end

  test "can?/3 with non-create_ permissions" do
    yes = %{permissions: ["edit_all_articles"]}
    no = %{permissions: ["edit_articles"]}

    assert User.can?(@super_user, "edit", "articles")
    assert User.can?(yes, "edit", "articles")
    refute User.can?(no, "edit", "articles")
  end

  test "can?/4" do
    obj  = %{author: 1}
    yes1 = %{id: 2, permissions: ["edit_all_articles"]}
    yes2 = %{id: 1, permissions: ["edit_articles"]}
    no   = %{id: 2, permissions: ["edit_articles"]}

    assert User.can?(@super_user, "edit", "articles", obj)
    assert User.can?(yes1, "edit", "articles", obj)
    assert User.can?(yes2, "edit", "articles", obj)
    refute User.can?(no, "edit", "articles", obj)
  end
end

