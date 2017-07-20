defmodule Core.QTest do
  use Core.ModelCase
  alias Core.Q

  setup do
    # Insert 2 users
    user = insert_user()
    root = insert_user(%{}, true)

    # Insert 2 articles
    # ar1 = insert_article()
    # ar2 = insert_article()

    # Insert 5 tags
    t1 = insert_tag()
    t2 = insert_tag()
    t3 = insert_tag()
    t4 = insert_tag()
    t5 = insert_tag()

    # # Insert 2 questions
    # q1 = insert_question([t1, t2], [])
    # q2 = insert_question([t3], [t4, t5])

    # # Insert 3 annotations
    # a1 = insert_annotation(ar1, t1)
    # a2 = insert_annotation(ar1, t2)
    # a3 = insert_annotation(ar2, t3)
    # a4 = insert_annotation(ar2, t4)
    # a5 = insert_annotation(ar2, t5)

    # # Insert 2 liqens
    # l1 = insert_liqen([a1, a2])
    # l2 = insert_liqen([a3, a4, a5])

    {:ok, %{# questions: [q1, q2],
        # annotations: [a1, a2, a3, a4, a5],
        tags: [t1, t2, t3, t4, t5],
        #liqens: [l1, l2],
        user: user,
        root: root
     }}
  end

  # test "Get Question", %{questions: [q1, q2]} do
  #expected = %{id: q1.id,
  # title: q1.title}

  # assert {:ok, expected} == Q.get_question(q1.id)
  #  end

  test "Get existing Tag", %{tags: [t1, _t2, _t3, _t4, _t5]} do
    expected = %{id: t1.id,
                 title: t1.title}

    assert {:ok, expected} == Q.get_tag(t1.id)
  end

  test "Get non-existing Tag", %{} do
    assert {:error, :not_found} == Q.get_tag(0)
  end

  test "Get all tags", %{tags: [t1, t2, t3, t4, t5]} do
    expected = [
      %{id: t1.id, title: t1.title},
      %{id: t2.id, title: t2.title},
      %{id: t3.id, title: t3.title},
      %{id: t4.id, title: t4.title},
      %{id: t5.id, title: t5.title}
    ]

    assert expected == Q.get_all_tags()
  end

  test "Create tag", %{root: root} do
    assert {:ok, _} = Q.create_tag(root, %{title: "Tag"})
  end

  test "Create non-valid tag", %{root: root} do
    assert {:error, %Ecto.Changeset{}} = Q.create_tag(root, %{})
  end

  test "Create tag without permissions", %{user: user} do
    assert {:error, :forbidden} = Q.create_tag(user, %{title: "Tag"})
  end
end
