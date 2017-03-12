defmodule Core.PrivateView do
  use Core.Web, :view

  def render("ok.json", %{}) do
    %{
      message: "Hello from the private zone!!"
    }
  end

  def render("unauthorized.json", _params) do
    %{
      message: "You must be logged in to access here"
    }
  end
end
