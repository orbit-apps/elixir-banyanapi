defmodule BanyanAPI.AppInstall do
  alias BanyanAPI.Client

  @spec create(map()) :: {:ok, %Neuron.Response{}} | {:error, any()}
  def create(nil), do: raise(ArgumentError, message: "Invalid shop value: nil")

  def create(shop) do
    Client.query(
      """
      mutation InstallApp($app_name: String!, $shop: AppShop!) {
        appInstall(
          app_name: $app_name,
          shop: $shop
      ) {
          app_name
        }
      }
      """,
      %{
        app_name: Application.get_env(:banyan_api, :app_name, ""),
        shop: format_shop_params(shop)
      }
    )
  end

  @spec update(map(), String.t()) :: {:ok, %Neuron.Response{}} | {:error, any()}
  def update(nil, _), do: raise(ArgumentError, message: "Invalid shop value: nil")

  def update(shop, status) do
    Client.query(
      """
      mutation updateAppInstall($app_name: String!, $shop: AppShop!, $status: String!) {
        appInstallUpdate(
          app_name: $app_name,
          shop: $shop,
          status: $status
      ) {
          app_name
        }
      }
      """,
      %{
        app_name: Application.get_env(:banyan_api, :app_name, ""),
        shop: format_shop_params(shop),
        status: status
      }
    )
  end

  @spec delete(map()) :: {:ok, %Neuron.Response{}} | {:error, any()}
  def delete(shop) do
    Client.query(
      """
      mutation UninstallApp($app_name: String!, $shop: AppShop!) {
        appUninstall(
          app_name: $app_name,
          shop: $shop
      ) {
          app_name
        }
      }
      """,
      %{
        app_name: Application.get_env(:banyan_api, :app_name, ""),
        shop: format_shop_params(shop)
      }
    )
  end

  @spec format_shop_params(map()) :: map()
  # WARNING the only supported keys right now are settings, this func needs to handle
  #         both strings and atoms as keys in the map.
  defp format_shop_params(%{settings: settings}),
    do: %{
      email: settings["email"],
      myshopify_domain: settings["myshopify_domain"]
    }

  defp format_shop_params(%{"settings" => settings}),
    do: format_shop_params(%{settings: settings})
end
