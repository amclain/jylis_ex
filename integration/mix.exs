defmodule Integration.MixProject do
  use Mix.Project

  def project do
    [
      app:               :jylis_integration,
      version:           "0.1.0",
      elixir:            "~> 1.6",
      deps:              deps(),
      start_permanent:   Mix.env() == :test,
      aliases:           [test: "espec"],
      preferred_cli_env: ["espec": :test]
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
      {:jylis_ex, ">= 0.0.0", path: ".."},
      {:espec,    "~> 1.5.1", only: :test},
    ]
  end
end
