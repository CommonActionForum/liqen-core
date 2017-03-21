defmodule Core.TestHelpers do
  alias Core.Repo

  def insert_user(attrs \\ %{}) do
    changes = Map.merge(%{email: "john#{Base.encode16(:crypto.strong_rand_bytes(8))}@example.com",
                          password: "secret",
                          role: "beta_user"}, attrs)

    %Core.User{}
    |> Core.User.changeset(changes)
    |> Repo.insert!()
  end

  def insert_tag(attrs \\ %{}) do
    changes = Map.merge(%{title: "Example tag"}, attrs)

    %Core.Tag{}
    |> Core.Tag.changeset(changes)
    |> Repo.insert!()
  end

  def insert_question(attrs \\ %{}) do
    changes = Map.merge(%{title: "Example question"}, attrs)

    %Core.Question{}
    |> Core.Question.changeset(changes)
    |> Repo.insert!()
  end

  def insert_article(attrs \\ %{}) do
    changes = Map.merge(%{title: "Example article",
                          body: "Example body"}, attrs)

    %Core.Article{}
    |> Core.Article.changeset(changes)
    |> Repo.insert!()
  end

  def insert_annotation(attrs \\ %{}) do
    changes = Map.merge(%{article_id: 0,
                          target: %{"type" => "FragmentSelector",
                                    "value" => "",
                                    "refinedBy" => %{"type" => "TextQuoteSelector",
                                                     "prefix" => "",
                                                     "exact" => "",
                                                     "suffix" => ""}}}, attrs)

    %Core.Annotation{}
    |> Core.Annotation.changeset(changes)
    |> Repo.insert!()
  end
end
