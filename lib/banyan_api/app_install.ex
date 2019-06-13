defmodule BanyanAPI.AppInstall do
  alias BanyanAPI.Client

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
