defmodule Core.ViewTestHelpers do
  @moduledoc """
  Helper functions to check views.

  Use this functions to check if an API retrieved value has been changed or not.

  Update this file when the API has been correctly.
  """

  @doc """
  Try to match a JSON `response` with a schema.
  """
  def check_view(response, schema)

  def check_view(response, "annotation.json") do
    %{"id" => _,
      "author" => _,
      "article_id" => _,
      "target" => _,
      "tags" => tags} = response

    check_array_view(tags, "tag.json")
  end

  def check_view(response, "error.json") do
    %{"errors" => _} = response
  end

  @doc """
  Try to match all elements of a JSON array `response` with a schema
  """
  def check_array_view(response, asset_or_fun \\ fn x -> x end)

  def check_array_view(response, "annotation.json") do
    check_array_view response, fn s ->
      %{"id" => _,
        "article_id" => _,
        "author" => _} = s
    end
  end

  def check_array_view(response, "tag.json") do
    check_array_view response, fn t ->
      %{"id" => _,
        "title" => _} = t
    end
  end

  def check_array_view(response, fun) do
    Enum.all?(response, fun)
  end
end
