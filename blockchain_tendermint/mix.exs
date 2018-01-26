defmodule BlockchainTendermint.MixProject do
  use Mix.Project

  def project do
    [
      app: :blockchain_tendermint,
      version: "0.1.0",
      elixir: "~> 1.6",
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
      # ABCI Server (Erlang) - Merkle Tree https://github.com/yosriady/merkle_tree
      # API Docs for ABCI Server (Erlang) - Merkle Tree - https://hexdocs.pm/merkle_tree/api-reference.html
      # List of ABCI Servers - http://tendermint.readthedocs.io/projects/tools/en/master/ecosystem.html?highlight=server#abci-servers
      {:merkle_tree, "~> 1.1.1", only: [:dev, :test, :prod]}
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end
end
