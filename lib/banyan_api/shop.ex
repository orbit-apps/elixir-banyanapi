defmodule BanyanAPI.Shop do
  alias BanyanAPI.Client

  @default_settings %{
    "address1" => "",
    "city" => "",
    "country" => "",
    "created_at" => "",
    "currency" => "",
    "customer_email" => "",
    "enabled_presentment_currencies" => "",
    "domain" => "",
    "email" => "",
    "id" => "",
    "myshopify_domain" => "",
    "name" => "",
    "phone" => "",
    "plan_display_name" => "",
    "plan_name" => "",
    "province" => "",
    "shop_owner" => "",
    "source" => "",
    "zip" => ""
  }

  @spec update(%{access_token: String.t(), settings: map()}) ::
          {:ok, %Neuron.Response{}} | {:error, any()}
  def update(%{
        access_token: token,
        created_date: shop_install_at,
        settings: settings
      }) do
    %{
      "address1" => address1,
      "city" => city,
      "country" => country,
      "created_at" => created_at,
      "currency" => currency,
      "customer_email" => customer_email,
      "enabled_presentment_currencies" => enabled_presentment_currencies,
      "domain" => domain,
      "email" => email,
      "id" => shopify_id,
      "myshopify_domain" => myshopify_domain,
      "name" => name,
      "phone" => phone,
      "plan_display_name" => plan_display_name,
      "plan_name" => plan_name,
      "province" => province,
      "shop_owner" => shop_owner,
      "source" => source,
      "zip" => zip
    } =
      Map.merge(
        @default_settings,
        remove_nil_values(settings)
      )

    Client.query(
      """
        mutation UpdateShop(
          $domain: String!,
          $shop_name: String!,
          $token: String!,
          $code: String!,
          $app_name: String!
          $address1: String!,
          $city: String!,
          $country: String!,
          $created_at: String!
          $currency: String!,
          $customer_email: String!,
          $email: String!,
          $enabled_presentment_currencies: [String],
          $install_date: String!,
          $shopify_id: String!,
          $myshopify_domain: String!,
          $name: String!,
          $phone: String!,
          $plan_display_name: String!,
          $plan_name: String!,
          $province: String!,
          $shop_owner: String!,
          $source: String!,
          $zip: String!
        ) {
          updateShop(
            address1: $address1,
            app_name: $app_name,
            city: $city,
            country: $country,
            created_at: $created_at,
            currency: $currency,
            customer_email: $customer_email,
            domain: $domain,
            email: $email,
            enabled_presentment_currencies: $enabled_presentment_currencies,
            installed_at: $install_date,
            myshopify_domain: $myshopify_domain,
            name: $name,
            phone: $phone,
            plan_display_name: $plan_display_name,
            plan_name: $plan_name,
            province: $province,
            shop_owner: $shop_owner,
            shopify_id: $shopify_id,
            source: $source,
            zip: $zip
          ) { domain }
          updateAuthToken(token: $token, shopName: $shop_name, code: $code, appName: $app_name) {
            shopName
          }
        }
      """,
      %{
        address1: address1,
        app_name: Application.get_env(:banyan_api, :app_name, ""),
        city: city,
        code: "",
        country: country,
        created_at: created_at,
        currency: currency,
        customer_email: customer_email,
        domain: domain,
        email: email,
        enabled_presentment_currencies: enabled_presentment_currencies,
        installed_at: shop_install_at,
        myshopify_domain: myshopify_domain,
        name: name,
        phone: phone,
        plan_display_name: plan_display_name,
        plan_name: plan_name,
        province: province,
        shop_name: myshopify_domain,
        shop_owner: shop_owner,
        shopify_id: shopify_id,
        # used to indicate who refered the merchant, sometimes null
        source: source || "",
        token: token,
        zip: zip
      }
    )
  end

  def update(args) do
    {:error, "Banyan.Shop.update called with invalid parameters, received #{inspect(args)}"}
  end

  defp remove_nil_values(nil), do: %{}

  defp remove_nil_values(settings) do
    settings
    |> Enum.map(fn {k, v} -> if v == nil, do: {k, ""}, else: {k, v} end)
    |> Enum.into(%{})
  end
end
