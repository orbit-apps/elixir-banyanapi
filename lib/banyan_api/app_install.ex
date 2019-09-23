defmodule BanyanAPI.AppInstall do
  alias BanyanAPI.Client

  @spec create(String.t()) :: {:ok, %Neuron.Response{}} | {:error, any()}
  def create(myshopify_domain) do
    Client.query(
      """
      mutation InstallApp($shop_myshopify_domain: String!, $app_name: String!) {
        appInstall(
          shop_myshopify_domain: $shop_myshopify_domain,
          app_name: $app_name
      ) {
          app_name
        }
      }
      """,
      %{
        shop_myshopify_domain: myshopify_domain,
        app_name: Application.get_env(:banyan_api, :app_name, "")
      }
    )
  end

  @spec update(String.t(), String.t()) :: {:ok, %Neuron.Response{}} | {:error, any()}
  def update(myshopify_domain, status) do
    Client.query(
      """
      mutation updateAppInstall($shop_myshopify_domain: String!, $app_name: String!, $status: String!) {
        appInstallUpdate(
          shop_myshopify_domain: $shop_myshopify_domain,
          app_name: $app_name,
          status: $status
      ) {
          app_name
        }
      }
      """,
      %{
        shop_myshopify_domain: myshopify_domain,
        app_name: Application.get_env(:banyan_api, :app_name, ""),
        status: status
      }
    )
  end

  @spec delete(String.t()) :: {:ok, %Neuron.Response{}} | {:error, any()}
  def delete(myshopify_domain) do
    Client.query(
      """
      mutation UninstallApp($shop_myshopify_domain: String!, $app_name: String!) {
        appUninstall(
          shop_myshopify_domain: $shop_myshopify_domain,
          app_name: $app_name
      ) {
          app_name
        }
      }
      """,
      %{
        shop_myshopify_domain: myshopify_domain,
        app_name: Application.get_env(:banyan_api, :app_name, "")
      }
    )
  end
end
