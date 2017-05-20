defmodule Core.CodeView do
  use Core.Web, :view

  def render("201.json", _) do
    %{
      message: "Resource created"
    }
  end
end
