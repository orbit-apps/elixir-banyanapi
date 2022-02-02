defmodule BanyanAPI.ThemeBot do
  alias BanyanAPI.Client

  @spec create(map()) :: {:ok, %Neuron.Response{}} | {:error, any()}
  def create(
        %{
          myshopify_domain: myshopify_domain,
          theme_id: theme_id,
          manifest_name: manifest_name
        } = params
      ) do
    Client.query(
      """
      mutation CreateThemeBot(
        $myshopify_domain: String!,
        $theme_id: String!,
        $manifest_name: String!,
        $app_name: String!,
        $options: Options
      ) {
        createThemeBot(
          myshopify_domain: $myshopify_domain,
          app_name: $app_name,
          theme_id: $theme_id,
          manifest_name: $manifest_name,
          options: $options
      ) {
          manifest_name
        }
      }
      """,
      %{
        myshopify_domain: myshopify_domain,
        theme_id: theme_id,
        manifest_name: manifest_name,
        app_name: Application.get_env(:banyan_api, :app_name, ""),
        options: Map.get(params, :options, %{})
      }
    )
  end
end
