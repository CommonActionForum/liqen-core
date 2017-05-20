defmodule Core.Target do
  @moduledoc """
  The target type.

  Internally it is a Map
  """
  @behaviour Ecto.Type
  @valid_types ["FragmentSelector", "XPathSelector", "CssSelector"]

  def type, do: :map

  # Default casting (map keys are atoms)
  def cast(target = %{type: "TextQuoteSelector",
                      prefix: _,
                      exact: _,
                      suffix: _}), do: {:ok, target}
  def cast(%{type: type,
             value: value,
             refinedBy: refinedBy}) when type in @valid_types do
    case cast(refinedBy) do
      :error ->
        :error

      {:ok, ref} ->
        {:ok, %{type: type,
                value: value,
                refinedBy: ref}}
    end
  end
  def cast(target = %{type: type,
                      value: _}) when type in @valid_types, do: {:ok, target}

  # Map keys are strings
  def cast(%{"type" => type,
             "prefix" => prefix,
             "exact" => exact,
             "suffix" => suffix}), do: cast(%{type: type,
                                              prefix: prefix,
                                              exact: exact,
                                              suffix: suffix})
  def cast(%{"type" => type,
             "value" => value,
             "refinedBy" => refinedBy}), do: cast(%{type: type,
                                                    value: value,
                                                    refinedBy: refinedBy})
  def cast(%{"type" => type,
             "value" => value}), do: cast(%{type: type,
                                            value: value})

  # Everything else is a failure though
  def cast(_), do: :error

  # When loading data from the database, we are guaranteed to
  # receive a map and we will
  # just return it to be stored in the schema struct.
  def load(data), do: cast(data)

  # When dumping data to the database, we *expect* an already
  # formatted Target, but any value could be inserted into the
  # struct, so we need guard against them.
  def dump(%{type: "TextQuoteSelector",
             prefix: prefix,
             exact: exact,
             suffix: suffix}), do: {:ok, %{"type" => "TextQuoteSelector",
                                           "prefix" => prefix,
                                           "exact" => exact,
                                           "suffix" => suffix}}
  def dump(%{type: type,
             value: value,
             refinedBy: refinedBy}) do
    case dump(refinedBy) do
      :error ->
        :error

      {:ok, ref} ->
        {:ok, %{"type" => type,
                "value" => value,
                "refinedBy" => ref}}
    end
  end
  def dump(%{type: type,
             value: value}), do: {:ok, %{"type" => type,
                                         "value" => value}}
end
