defmodule Core.Repo do
  @moduledoc """
  Defines the repository. It doesn't change the default implementation, i.e.
  `Ecto.Repo`.
  """
  use Ecto.Repo, otp_app: :core
end
