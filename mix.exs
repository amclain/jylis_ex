defmodule JylisEx.MixProject do
  use Mix.Project

  def project do
    [
      app:               :jylis_ex,
      version:           "0.1.0",
      elixir:            "~> 1.6",
      package:           package(),
      deps:              deps(),
      name:              "jylis_ex",
      description:       description(),
      start_permanent:   Mix.env() == :prod,
      preferred_cli_env: [espec: :test],
      aliases:           [test: "espec"],
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [
        :logger,
      ]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      {:espec,  "~> 1.5.1", only: :test},
      {:ex_doc, ">= 0.0.0", only: :dev},
    ]
  end

  defp description do
    "An idiomatic library for connecting an Elixir project to a Jylis database."
  end

  defp package do
    [
      name:        "jylis_ex",
      maintainers: ["Alex McLain"],
      licenses:    ["MIT"],
      links:       %{"GitHub" => "https://github.com/amclain/jylis_ex"},
      files:       [
        "lib",
        "mix.exs",
        "README.md",
        "license.txt",
      ],
    ]
  end
end
