defmodule Core.AnnotationTest do
  use Core.ModelCase
  alias Core.Annotation

  @valid_target %{"type" => "TextQuoteSelector",
                  "prefix" => "",
                  "suffix" => "",
                  "exact" => ""}

  @valid_attrs %{target: @valid_target,
                 article_id: 1,
                 tags: [1, 2, 3]}

  test "converts foreign_key_constraint to error" do
    article = insert_article()
    invalid_attrs = %{target: @valid_target,
                      article_id: article.id + 10000}

    invalid_changeset = Annotation.changeset(%Annotation{}, invalid_attrs)

    assert {:error, _} = Repo.insert(invalid_changeset)
  end

  test "valid attrs" do
    changeset = Annotation.changeset(%Annotation{}, @valid_attrs)
    assert changeset.valid?
  end

  test "invalid attrs" do
    invalid_attrs1 = %{target: %{},
                       article_id: 1}

    invalid_attrs2 = %{target: %{}}

    changeset1 = Annotation.changeset(%Annotation{}, invalid_attrs1)
    changeset2 = Annotation.changeset(%Annotation{}, invalid_attrs2)

    refute changeset1.valid?
    refute changeset2.valid?
  end

  test "query/1" do
    user1 = insert_user()
    user2 = insert_user()
    article1 = insert_article()
    article2 = insert_article()

    insert_annotation(user1, %{article_id: article1.id})
    insert_annotation(user1, %{article_id: article2.id})
    insert_annotation(user2, %{article_id: article1.id})
    insert_annotation(user2, %{article_id: article2.id})

    query1 = Annotation.query(%{})
    query2 = Annotation.query(%{"article_id" => article1.id})
    query3 = Annotation.query(%{"author" => user1.id})

    annotations1 = Repo.all(query1)
    annotations2 = Repo.all(query2)
    annotations3 = Repo.all(query3)

    assert Enum.count(annotations1) == 4
    assert Enum.count(annotations2) == 2
    assert Enum.count(annotations3) == 2

    filtered2 = Enum.filter(annotations2, fn(a) -> a.article_id == article1.id end)
    assert Enum.count(filtered2) == 2

    filtered3 = Enum.filter(annotations3, fn(a) -> a.author == user1.id end)
    assert Enum.count(filtered3) == 2
  end
end
