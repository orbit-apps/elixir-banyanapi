defmodule BanyanAPI.AppInstall do
  alias BanyanAPI.Client

  @spec create(map() | nil, map()) :: {:ok, %Neuron.Response{}} | {:error, any()}
  def create(shop, metadata \\ %{})

  def create(nil, _), do: raise(ArgumentError, message: "Invalid shop value: nil")

  def create(shop, metadata) do
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
        shop: format_shop_params(shop, metadata)
      }
    )
  end

  @spec update(map() | nil, String.t(), map()) :: {:ok, %Neuron.Response{}} | {:error, any()}
  def update(shop, status, metadata \\ %{})
  def update(nil, _, _), do: raise(ArgumentError, message: "Invalid shop value: nil")

  def update(shop, status, metadata) do
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
        shop: format_shop_params(shop, metadata),
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

  @spec format_shop_params(map(), map()) :: map()
  # WARNING the only supported keys right now are:
  # - settings from the Shop map
  # - billing_plan_name from the metadata map
  # Also, this func needs to handle both strings and atoms as keys in the Shop map.
  defp format_shop_params(shop, metadata \\ %{})

  defp format_shop_params(%{settings: settings}, metadata),
    do: %{
      email: settings["email"],
      myshopify_domain: settings["myshopify_domain"],
      billing_plan_name: Map.get(metadata, :billing_plan_name)
    }

  defp format_shop_params(%{"settings" => settings}, metadata),
    do: format_shop_params(%{settings: settings}, metadata)
end
