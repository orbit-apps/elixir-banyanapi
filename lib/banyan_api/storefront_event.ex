defmodule BanyanAPI.StorefrontEvent do
  alias BanyanAPI.Client

  @spec track(map(), String.t(), map()) :: {:ok, %Neuron.Response{}} | {:error, any()}
  def track(shop, type, %{shopify_order: shopify_order}) do
    Client.query(
      """
      mutation TrackStorefrontEvent(
        $app_name: String!,
        $shop_myshopify_domain: String!,
        $shopify_order: String,
        $type: String!
      ) {
        trackStorefrontEvent(
          app_name: $app_name,
          shop_myshopify_domain: $shop_myshopify_domain,
          shopify_order: $shopify_order,
          type: $type
        ) {
          app_name
        }
      }
      """,
      %{
        app_name: Application.get_env(:banyan_api, :app_name, ""),
        shop_myshopify_domain: shop.settings["myshopify_domain"],
        shopify_order: Jason.encode!(shopify_order),
        type: type
      }
    )
  end
end
