defmodule BanyanAPI.AdminEvent do
  alias BanyanAPI.Client

  @spec track(map(), String.t(), map()) :: {:ok, %Neuron.Response{}} | {:error, any()}
  def track(shop, type, %{offer: offer} = payload) do
    Client.query(
      """
      mutation TrackAdminEvent(
        $app_name: String!,
        $email: String!,
        $offer: String,
        $offer_active: Boolean,
        $shop_myshopify_domain: String!,
        $type: String!
      ) {
        trackAdminEvent(
          app_name: $app_name,
          email: $email,
          offer: $offer,
          offer_active: $offer_active,
          shop_myshopify_domain: $shop_myshopify_domain,
          type: $type
        ) {
          app_name
        }
      }
      """,
      %{
        app_name: Application.get_env(:banyan_api, :app_name, ""),
        email: shop.settings["email"],
        offer: Jason.encode!(offer),
        offer_active: Map.get(payload, :offer_active),
        shop_myshopify_domain: shop.settings["myshopify_domain"],
        type: type
      }
    )
  end
end
