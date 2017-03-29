defmodule Core.Target do
  @behaviour Ecto.Type
  @valid_types ["FragmentSelector", "XPathSelector", "CssSelector"]

  def type, do: :map

  def cast(target = %{"type" => "TextQuoteSelector",
                      "prefix" => _,
                      "exact" => _,
                      "suffix" => _}), do: {:ok, target}
  def cast(target = %{"type" => type,
                      "value" => _,
                      "refinedBy" => refinedBy}) when type in @valid_types do
    case cast(refinedBy) do
      :error -> :error
      {:ok, _} -> {:ok, target}
    end
  end
  def cast(target = %{"type" => type,
                      "value" => _}) when type in @valid_types do
      {:ok, target}
  end

  # Everything else is a failure though
  def cast(_), do: :error

  # When loading data from the database, we are guaranteed to
  # receive a map and we will
  # just return it to be stored in the schema struct.
  def load(data), do: {:ok, data}

  # When dumping data to the database, we *expect* an already
  # formatted Target, but any value could be inserted into the
  # struct, so we need guard against them.
  def dump(body), do: cast(body)
end
