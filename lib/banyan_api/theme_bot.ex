defmodule BanyanAPI.ThemeBot do
  alias BanyanAPI.Client

  @doc """
  ## Params
    Map with the following keys
      - myshopify_domain
      - app_name
      - theme_id
      - manifest_name
      - options (optional): map
  """
  @spec create(map()) :: {:ok, %Neuron.Response{}} | {:error, any()}
  def create(params) do
    theme_bot_options = Map.get(params, :options, %{})
    Client.query(
      """
      mutation CreateThemeBot(
        $myshopify_domain: String!,
        $theme_id: String!,
        $manifest_name: String!,
        $app_name: String!,
        $options: ThemeBotOptions!
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
        myshopify_domain: params.myshopify_domain,
        theme_id: params.theme_id,
        manifest_name: params.manifest_name,
        app_name: Application.get_env(:banyan_api, :app_name, ""),
        options: theme_bot_options
      }
    )
  end
end
