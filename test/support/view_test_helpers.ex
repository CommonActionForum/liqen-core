defmodule Core.ViewTestHelpers do
  @moduledoc """
  Helper functions to check views.

  Use this functions to check if an API retrieved value has been changed or not.

  Update this file when the API has been correctly.
  """

  @doc """
  Try to match a JSON `response` with a schema.
  """
  def check_view(response, "annotation.json") do
    %{"id" => _,
      "author" => _,
      "article_id" => _,
      "target" => _,
      "tags" => tags} = response

    Enum.all?(tags, fn tag ->
      %{"id" => _,
        "title" => _} = tag
    end)
  end

  def check_view(response, "error.json") do
    %{"errors" => _} = response
  end

  def check_view(response, "summary.json") do
    [] = response
  end
end
