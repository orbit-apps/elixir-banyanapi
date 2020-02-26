defmodule BanyanAPI.StorefrontEvent do
  alias BanyanAPI.Client

  @spec track(map(), String.t(), map()) :: {:ok, %Neuron.Response{}} | {:error, any()}
  def track(shop, "net_terms_checkout" = type, payload) do
    Client.query(
      """
      mutation TrackStorefrontEvent(
        $app_name: String!,
        $email: String!,
        $shop_myshopify_domain: String!,
        $type: String!
        $shopify_order: String,
        $recipient_email: String,
      ) {
        trackStorefrontEvent(
          app_name: $app_name,
          email: $email,
          shop_myshopify_domain: $shop_myshopify_domain,
          type: $type
          shopify_order: $shopify_order,
          recipient_email: $recipient_email,
        ) {
          app_name
        }
      }
      """,
      %{
        app_name: Application.get_env(:banyan_api, :app_name, ""),
        email: shop.settings["email"],
        shop_myshopify_domain: shop.settings["myshopify_domain"],
        type: type,
        shopify_order: payload |> Map.get(:shopify_order) |> encode_order_if_exists!(),
        recipient_email: Map.get(payload, :recipient_email)
      }
    )
  end

  def track(shop, "order.created" = type, payload) do
    Client.query(
      """
      mutation TrackStorefrontEvent(
        $app_name: String!,
        $email: String!,
        $shop_myshopify_domain: String!,
        $type: String!
        $shopify_order: String,
        $checkout_source: String,
      ) {
        trackStorefrontEvent(
          app_name: $app_name,
          email: $email,
          shop_myshopify_domain: $shop_myshopify_domain,
          type: $type
          shopify_order: $shopify_order,
          checkout_source: $checkout_source
        ) {
          app_name
        }
      }
      """,
      %{
        app_name: Application.get_env(:banyan_api, :app_name, ""),
        email: shop.settings["email"],
        shop_myshopify_domain: shop.settings["myshopify_domain"],
        type: type,
        shopify_order: payload |> Map.get(:shopify_order) |> encode_order_if_exists!(),
        checkout_source: Map.get(payload, :checkout_source)
      }
    )
  end

  defp encode_order_if_exists!(order) when is_map(order), do: Jason.encode!(order)
  defp encode_order_if_exists!(_), do: nil
end
