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

    # Insert 2 questions
    q1 = insert_authored_question(root)
    q2 = insert_authored_question(root)

    # Link questions with tags
    insert_question_tag(q1, t2, true)
    insert_question_tag(q1, t3, true)
    insert_question_tag(q1, t4, false)
    insert_question_tag(q1, t5, false)

    insert_question_tag(q2, t2, true)
    insert_question_tag(q2, t3, true)
    insert_question_tag(q2, t4, true)

    # # Insert 3 annotations
    # a1 = insert_annotation(ar1, t1)
    # a2 = insert_annotation(ar1, t2)
    # a3 = insert_annotation(ar2, t3)
    # a4 = insert_annotation(ar2, t4)
    # a5 = insert_annotation(ar2, t5)

    # # Insert 2 liqens
    # l1 = insert_liqen([a1, a2])
    # l2 = insert_liqen([a3, a4, a5])

    {:ok, %{questions: [q1, q2],
            # annotations: [a1, a2, a3, a4, a5],
            tags: [t1, t2, t3, t4, t5],
            #liqens: [l1, l2],
            user: user,
            root: root}}
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

    assert {:ok, expected} == Q.get_all_tags()
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

  test "Update tag", %{root: root, tags: [t1, _, _, _, _]} do
    expected = %{title: "Tagg",
                 id: t1.id}

    assert {:ok, expected} == Q.update_tag(root, t1.id, %{title: "Tagg"})
  end

  test "Update tag. Some fields ignored", %{root: root, tags: [t1, _, _, _, _]} do
    expected = %{title: "Tagg",
                 id: t1.id}

    assert {:ok, expected} == Q.update_tag(root, t1.id, %{title: "Tagg", id: 89})
  end

  test "Update not found", %{root: root} do
    assert {:error, :not_found} = Q.update_tag(root, 0, %{})
  end

  test "Update without parameters", %{root: root, tags: [t1, _, _, _, _]} do
    expected = %{title: t1.title,
                 id: t1.id}

    assert {:ok, expected} == Q.update_tag(root, t1.id, %{})
  end

  test "Update without permissions", %{user: user, tags: [t1, _, _, _, _]} do
    assert {:error, :forbidden} = Q.update_tag(user, t1.id, %{title: "Tagg"})
  end

  test "Delete tag", %{root: root, tags: [t1, _, _, _, _]} do
    expected = %{title: t1.title,
                 id: t1.id}

    assert {:ok, expected} == Q.delete_tag(root, t1.id)
  end

  test "Delete tag without permissions", %{user: user, tags: [t1, _, _, _, _]} do
    assert {:error, :forbidden} = Q.delete_tag(user, t1.id)
  end

  test "Delete tag not found", %{root: root, tags: [_, _, _, _, _]} do
    assert {:error, :not_found} = Q.delete_tag(root, 0)
  end

  test "Delete tag included in a question", %{root: root, tags: [_, t2, _, _, _]} do
    assert {:error, :bad_request, _} = Q.delete_tag(root, t2.id)
  end

  test "Get existing Question", %{questions: [q1, _], root: root, tags: [_, t2, t3, t4, t5]} do
    expected = %{id: q1.id,
                 title: q1.title,
                 author: %{id: root.id,
                           name: root.name},
                 required_tags: [
                   %{id: t2.id, title: t2.title},
                   %{id: t3.id, title: t3.title}
                 ],
                 optional_tags: [
                   %{id: t4.id, title: t4.title},
                   %{id: t5.id, title: t5.title}
                 ]}

    assert {:ok, expected} == Q.get_question(q1.id)
  end

  test "Get non-existing Question", %{} do
    assert {:error, :not_found} == Q.get_question(0)
  end

  test "Get all questions", %{questions: [q1, q2], root: root} do
    author = %{id: root.id, name: root.name}
    expected = [
      %{id: q1.id, title: q1.title, author: author},
      %{id: q2.id, title: q2.title, author: author}
    ]

    assert {:ok, expected} == Q.get_all_questions()
  end

  test "Create Question", %{root: root, tags: [t1, t2, t3, _, _]} do
    {:ok, q} = Q.create_question(root, %{title: "Question",
                                         required_tags: [t1.id, t2.id],
                                         optional_tags: [t3.id]})

    assert q == %{
      id: q.id,
      title: "Question",
      author: %{
        id: root.id,
        name: root.name
      },
      required_tags: [
        %{id: t1.id, title: t1.title},
        %{id: t2.id, title: t2.title}
      ],
      optional_tags: [
        %{id: t3.id, title: t3.title}
      ]
    }
  end

  test "Create non-valid question (no title present)", %{root: root} do
    assert {:error, %Ecto.Changeset{}} = Q.create_tag(root, %{})
  end

  test "Create non-valid question (tags repeated)", %{root: root, tags: [t1, t2, t3, _, _]} do
    {:error, %Ecto.Changeset{}} = Q.create_question(
      root,
      %{
        title: "Question",
        required_tags: [t1.id, t2.id],
        optional_tags: [t1.id, t3.id]
      }
    )
  end

  test "Create non-valid question (non-existing tags)", %{root: root, tags: [t1, t2, _,  _, _]} do
    {:error, %Ecto.Changeset{}} = Q.create_question(
      root,
      %{
        title: "Question",
        required_tags: [t1.id, 0],
        optional_tags: [t2.id, 0]
      }
    )
  end

  test "Create question without permissions", %{user: user} do
    assert {:error, :forbidden} = Q.create_tag(user, %{title: "Tag"})
  end
end
