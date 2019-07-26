defmodule BanyanAPI.Shop do
  alias BanyanAPI.Client

  @default_settings %{
    "address1" => "",
    "city" => "",
    "country" => "",
    "currency" => "",
    "customer_email" => "",
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
        settings: settings
      }) do
    %{
      "address1" => address1,
      "city" => city,
      "country" => country,
      "currency" => currency,
      "customer_email" => customer_email,
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
        settings,
        fn _, v1, v2 -> if v2 == nil, do: v1, else: v2 end
      )

    Client.query(
      """
        mutation CreateShop(
          $domain: String!,
          $shop_name: String!,
          $token: String!,
          $code: String!,
          $app_name: String!
          $address1: String!,
          $city: String!,
          $country: String!,
          $currency: String!,
          $customer_email: String!,
          $email: String!,
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
            city: $city,
            country: $country,
            currency: $currency,
            customer_email: $customer_email,
            domain: $domain,
            myshopify_domain: $myshopify_domain,
            email: $email,
            shopify_id: $shopify_id,
            name: $name,
            phone: $phone,
            plan_display_name: $plan_display_name,
            plan_name: $plan_name,
            province: $province,
            shop_owner: $shop_owner,
            source: $source,
            zip: $zip
          ) { domain }
          updateAuthToken(token: $token, shopName: $shop_name, code: $code, appName: $app_name) {
            shopName
          }
          appInstall(appName: $app_name, shop_myshopify_domain: $myshopify_domain ) { appName }
        }
      """,
      %{
        address1: address1,
        app_name: Application.get_env(:banyan_api, :app_name, ""),
        city: city,
        code: "",
        country: country,
        currency: currency,
        customer_email: customer_email,
        domain: domain,
        email: email,
        shopify_id: shopify_id,
        myshopify_domain: myshopify_domain,
        name: name,
        shop_name: myshopify_domain,
        phone: phone,
        plan_display_name: plan_display_name,
        plan_name: plan_name,
        province: province,
        shop_owner: shop_owner,
        # used to indicate who refered the merchant, sometimes null
        source: source || "",
        token: token,
        zip: zip
      }
    )
  end

  def update(args),
    do:
      {:error,
       "Banyan.Shop.update called with invalid parameters, received #{Kernel.inspect(args)}"}
end
