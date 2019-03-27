defmodule SlackAPI.MixProject do
  use Mix.Project

  def project do
    [
      app: :slack_api,
      version: "0.1.0",
      elixir: "~> 1.8",
      elixirc_paths: elixirc_paths(Mix.env),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {SlackAPI.Application, []}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:websockex, "~> 0.4.0"},
      {:httpoison, "~> 0.12"},
      {:poison, "~> 3.0"},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:cowboy, "~> 2.0", only: :test},
      {:plug_cowboy, "~> 2.0", override: true, only: :test},
      {:mox, "~> 0.5", only: :test},
      {:bypass, "~> 1.0", only: :test}
    ]
  end
end
