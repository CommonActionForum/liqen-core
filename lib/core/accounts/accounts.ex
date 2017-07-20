defmodule Core.Accounts do
  alias Core.Repo
  alias Core.Accounts.User

  def get_user(id) do
    case Repo.get(User, id) do
      %User{} = user ->
        {:ok, user}
      _ ->
        {:error, :not_found}
    end
  end
end
