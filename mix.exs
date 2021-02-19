defmodule BanyanAPI.MixProject do
  use Mix.Project

  @version "0.6.3"

  def project do
    [
      app: :banyan_api,
      version: @version,
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: [
        plt_add_apps: [:mix, :ex_unit],
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
      ]
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
      {:credo, "~> 1.5.2", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.1.0", only: [:dev, :test], runtime: false},
      # everything else
      {:neuron, "~> 5.0.0"},
      {:pxu_auth0, github: "pixelunion/ex-pxu-auth0", tag: "v0.2.2"}
    ]
  end
end
