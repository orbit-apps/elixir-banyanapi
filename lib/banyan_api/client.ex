defmodule BanyanAPI.Client do
  alias BanyanAPI.TimeoutError
  alias Neuron.Config
  alias PxUAuth0.AccessToken

  require Logger

  @default_access_token_impl &AccessToken.fetch/0

  @spec query(String.t(), map()) :: {:ok, map()} | {:error, any()}
  def query(query, params) do
    Config.set(url: Application.get_env(:banyan_api, :graphql_endpoint, ""))
    Config.set(headers: headers())

    query
    |> Neuron.query(params)
    |> log_and_return!()
  end

  defp headers do
    {:ok, auth0_token} = access_token_impl().()
    [Authentication: "Bearer #{auth0_token}"]
  end

  defp log_and_return!({:ok, %{body: %{"errors" => errors}} = response}) do
    error_string = Enum.map_join(errors, " ", &Map.get(&1, "message"))

    Logger.error("#{__MODULE__} call errored: #{error_string}")

    {:error, response}
  end

  defp log_and_return!({:ok, _} = response) do
    Logger.debug("#{__MODULE__} successfully called")
    response
  end

  defp log_and_return!({:error, %HTTPoison.Error{reason: :timeout}}), do: raise(TimeoutError)

  defp log_and_return!({_, error} = response) do
    Logger.error("#{__MODULE__} call errored: #{inspect(error)}")
    response
  end

  defp access_token_impl,
    do: Application.get_env(:banyan_api, :access_token_impl, @default_access_token_impl)
end
