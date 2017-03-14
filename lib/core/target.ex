defmodule Core.Target do
  @behaviour Ecto.Type
  @valid_types ["FragmentSelector", "XPathSelector", "CssSelector"]

  def type, do: :map

  # Only accept "Targets" with a certain shape
  # - type must be one of @valid_types
  # - etc...
  def cast(%{"type" => type,
             "value" => value,
             "refinedBy" => %{"type" => "TextQuoteSelector",
                              "prefix" => prefix,
                              "exact" => exact,
                              "suffix" => suffix}
            }) when type in @valid_types do

    {:ok, %{"type" => type,
            "value" => value,
            "prefix" => prefix,
            "exact" => exact,
            "suffix" => suffix}}
  end

  # Everything else is a failure though
  def cast(_), do: :error

  # When loading data from the database, we are guaranteed to
  # receive a map and we will
  # just return it to be stored in the schema struct.
  def load(target), do: {:ok, target}

  # When dumping data to the database, we *expect* an already
  # formatted Target, but any value could be inserted into the
  # struct, so we need guard against them.
  def dump(%{"type" => type,
             "value" => value,
             "prefix" => prefix,
             "exact" => exact,
             "suffix" => suffix}) do

    {:ok, %{"type" => type,
            "value" => value,
            "prefix" => prefix,
            "exact" => exact,
            "suffix" => suffix}}
  end
  def dump(_), do: :error
end
