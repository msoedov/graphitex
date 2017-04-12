defmodule Graphitex.Mixfile do
  use Mix.Project

  def project do
    [app: :graphitex,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: "Graphite tcp client",
     package: package(),
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [ mod: {Graphitex, []},
      applications: [:logger],
      registered: [Graphitex.Client],
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE"],
      maintainers: ["Alex Myasoedov"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/msoedov/graphitex"},
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:ex_doc, ">= 0.0.0", only: :dev}]
  end
end
