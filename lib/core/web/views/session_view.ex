defmodule Core.Web.SessionView do
  use Core.Web, :view

  def render("ok.json", %{session: session}) do
    %{
      access_token: session.jwt,
      expires: session.exp,
      user: %{
        id: session.user.id
      }
    }
  end

  def render("unauthorized.json", _params) do
    %{
      message: "Wrong email or password"
    }
  end
end
