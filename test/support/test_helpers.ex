defmodule Core.TestHelpers do
  alias Core.Repo

  def insert_user(attrs \\ %{}) do
    changes = Map.merge(%{email: "john#{Base.encode16(:crypto.strong_rand_bytes(8))}@example.com",
                          password: "secret"}, attrs)

    %Core.User{}
    |> Core.User.changeset(changes)
    |> Repo.insert!()
  end
end
