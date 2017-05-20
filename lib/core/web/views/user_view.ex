defmodule Core.Web.UserView do
  use Core.Web, :view

  def render("forbidden.json", %{}) do
    %{
      message: "User creation is not permitted via API calls"
    }
  end

  @doc """
  Renders a JSON when some parameters are wrong or missing
  """
  def render("bad_request.json", %{errors: errors}) do
    invalid_params = Enum.map errors, fn({field, {reason, _}}) ->
      %{field: field, reason: reason}
    end

    %{
      message: "Some parameters are wrong or missing",
      invalid_params: invalid_params
    }
  end

  @doc """
  Renders a JSON when a new user is successfully created
  """
  def render("created.json", %{user: user}) do
    %{
      message: "User successfully created",
      user: %{
        id: user.id,
        email: user.email
      }
    }
  end

  def render("show.json", %{user: user}) do
    %{
      id: user.id,
      email: user.email
    }
  end
end
