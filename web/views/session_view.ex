defmodule Core.SessionView do
  use Core.Web, :view

  def render("ok.json", %{session: session}) do
    session
  end

  def render("unauthorized.json", _params) do
    %{
      message: "Wrong email or password"
    }
  end
end
