defmodule BanyanAPI.Anonymizers.ShopifyAddress do
  @valid_address_fields [
    "city",
    "country_code",
    "country_name",
    "province",
    "zip"
  ]

  @spec clean(any()) :: map()
  def clean(address) when is_map(address), do: Map.take(address, @valid_address_fields)
  def clean(_), do: %{}

  @spec address_fields() :: list(String.t())
  def address_fields, do: @valid_address_fields
end
