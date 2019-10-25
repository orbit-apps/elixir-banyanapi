defmodule BanyanAPI.StorefrontEvent do
  alias BanyanAPI.Client

  @spec track(map(), String.t(), map()) :: {:ok, %Neuron.Response{}} | {:error, any()}
  def track(shop, type, payload) do
    Client.query(
      """
      mutation TrackStorefrontEvent(
        $app_name: String!,
        $email: String!,
        $shop_myshopify_domain: String!,
        $shopify_order: String,
        $recipient_email: String,
        $type: String!
      ) {
        trackStorefrontEvent(
          app_name: $app_name,
          email: $email,
          shop_myshopify_domain: $shop_myshopify_domain,
          shopify_order: $shopify_order,
          recipient_email: $recipient_email,
          type: $type
        ) {
          app_name
        }
      }
      """,
      %{
        app_name: Application.get_env(:banyan_api, :app_name, ""),
        email: shop.settings["email"],
        shop_myshopify_domain: shop.settings["myshopify_domain"],
        shopify_order: payload |> Map.get(:order, %{}) |> Jason.encode!(),
        recipient_email: Map.get(payload, :recipient_email, ""),
        type: type
      }
    )
  end
end
