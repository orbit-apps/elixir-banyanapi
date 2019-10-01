defmodule BanyanAPI.Anonymizers.ShopifyOrder do
  alias BanyanAPI.Anonymizers.ShopifyAddress

  @order_fields_omit [
    "contact_email",
    "email",
    "fulfillments"
  ]

  @spec clean(any()) :: map()
  def clean(order) when is_map(order) do
    order
    |> Map.put("customer", gen_customer(order))
    |> Map.put("billing_address", order |> Map.get("billing_address") |> ShopifyAddress.clean())
    |> Map.put("shipping_address", order |> Map.get("shipping_address") |> ShopifyAddress.clean())
    |> Map.drop(@order_fields_omit)
  end

  def clean(_), do: %{}

  defp gen_customer(order), do: %{"id" => get_in(order, ["customer", "id"])}
end
