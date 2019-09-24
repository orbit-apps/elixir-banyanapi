defmodule BanyanAPI.AppInstall do
  alias BanyanAPI.Client

  @spec create(map()) :: {:ok, %Neuron.Response{}} | {:error, any()}
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
        shop: shop
      }
    )
  end

  @spec update(map(), String.t()) :: {:ok, %Neuron.Response{}} | {:error, any()}
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
        shop: shop,
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
        shop: shop
      }
    )
  end
end
