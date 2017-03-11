defmodule Core.UserView do
  use Core.Web, :view

  def render("forbidden.json", %{registration: registration}) do
    %{
      message: "User creation is not permitted via API calls"
    }
  end
end
