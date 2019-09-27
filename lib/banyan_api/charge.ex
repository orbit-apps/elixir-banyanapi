defmodule BanyanAPI.Charge do
  alias BanyanAPI.Client

  @spec track(map(), map()) :: {:ok, %Neuron.Response{}} | {:error, any()}
  def track(shop, shopify_charge) do
    Client.query(
      """
      mutation TrackCharge(
        $app_name: String!,
        $shop_myshopify_domain: String!,
        $shopify_charge: String!
      ) {
        trackCharge(
          app_name: $app_name,
          shop_myshopify_domain: $shop_myshopify_domain,
          shopify_charge: $shopify_charge
        ) {
          app_name
        }
      }
      """,
      %{
        app_name: Application.get_env(:banyan_api, :app_name, ""),
        shop_myshopify_domain: shop.settings["myshopify_domain"],
        shopify_charge: Jason.encode!(shopify_charge)
      }
    )
  end
end
