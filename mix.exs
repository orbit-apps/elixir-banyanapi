defmodule BanyanAPI.MixProject do
  use Mix.Project

  @version "0.4.3"

  def project do
    [
      app: :banyan_api,
      version: @version,
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Test and Dev
      {:credo, "~> 1.1.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0.0-rc.4", only: :dev, runtime: false},
      # everything else
      {:neuron, "~> 4.1.1"},
      {:pxu_auth0, github: "pixelunion/ex-pxu-auth0", tag: "v0.2.0"}
    ]
  end
end
