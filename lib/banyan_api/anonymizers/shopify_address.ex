defmodule BanyanAPI.Anonymizers.ShopifyAddress do
  @address_fields_omit [
    "first_name",
    "last_name",
    "name",
    "phone",
    "address1",
    "address2"
  ]

  @spec clean(any()) :: map()
  def clean(address) when is_map(address), do: Map.drop(address, @address_fields_omit)
  def clean(_), do: %{}
end
