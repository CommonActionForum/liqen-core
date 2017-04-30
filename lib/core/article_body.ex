defmodule Core.ArticleBody do
  @moduledoc """
  This module defines the `ArticleBody` type. Represents the body of an article.

  It is an array of `Element`s. An `Element` is a map with three fields:

  - `id` an optional string.
  - `name` a string.
  - `children` an array of Nodes.

  A Node is a `string` or an `Element`
  """
  @behaviour Ecto.Type

  def type, do: {:array, :map}

  @doc """
  Check if `body` is a valid Article Body
  """
  def cast(body) do
    cast_children(body)
  end

  @doc """
  Check if an `element` is an Element.
  """
  def cast_element(element)
  def cast_element(%{"id" => id, "name" => name, "children" => children}) do
    case cast_children(children) do
      :error -> :error
      {:ok, children} -> {:ok, %{"id" => id,
                                "name" => name,
                                "children" => children}}
    end
  end
  def cast_element(%{"name" => name,
                     "children" => children}) do
    cast_element(%{"name" => name,
                   "id" => "",
                   "children" => children})
  end
  def cast_element(_), do: :error

  @doc """
  Check if `children` is a valid array of Nodes.
  """
  def cast_children(children) when is_list(children) do
    children
    |> Enum.map(&cast_node/1)
    |> Enum.reduce({:ok, []}, fn(x, acc) ->
      if acc == :error do
        :error
      else case x do
             :error -> :error
             {:ok, something} ->
               {:ok, list} = acc
               {:ok, list ++ [something]}
           end
      end
    end)
  end
  def cast_children(_), do: :error

  @doc """
  Check if `node` is a Node
  """
  def cast_node(node)
  def cast_node(str) when is_bitstring(str), do: {:ok, str}
  def cast_node(element), do: cast_element(element)

  # When loading data, we return it as it.
  def load(data), do: {:ok, data}

  # When dumping data to the database, we *expect* an already
  # formatted ArticleBody, but any value could be inserted into the
  # struct, so we need guard against them.
  def dump(body), do: cast(body)
end
