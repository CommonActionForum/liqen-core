defmodule Core.PermissionsTest do
  use Core.ModelCase
  alias Core.Permissions

  @super_user %{permissions: ["super_user"]}

  test "can?/2 with valid permissions" do
    user = %{permissions: ["perm1"]}

    assert Permissions.can?(user, "perm1")
  end

  test "can?/3 with create_ permissions" do
    yes = %{permissions: ["create_articles"]}
    no = %{permissions: ["create_all_articles"]}

    assert Permissions.can?(@super_user, "create", "articles")
    assert Permissions.can?(yes, "create", "articles")
    refute Permissions.can?(no, "create", "articles")
  end

  test "can?/3 with non-create_ permissions" do
    yes = %{permissions: ["edit_all_articles"]}
    no = %{permissions: ["edit_articles"]}

    assert Permissions.can?(@super_user, "edit", "articles")
    assert Permissions.can?(yes, "edit", "articles")
    refute Permissions.can?(no, "edit", "articles")
  end

  test "can?/4" do
    obj  = %{author: 1}
    yes1 = %{id: 2, permissions: ["edit_all_articles"]}
    yes2 = %{id: 1, permissions: ["edit_articles"]}
    no   = %{id: 2, permissions: ["edit_articles"]}

    assert Permissions.can?(@super_user, "edit", "articles", obj)
    assert Permissions.can?(yes1, "edit", "articles", obj)
    assert Permissions.can?(yes2, "edit", "articles", obj)
    refute Permissions.can?(no, "edit", "articles", obj)
  end
end

