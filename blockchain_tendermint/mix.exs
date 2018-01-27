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
  # Versioning - https://hexdocs.pm/elixir/Version.html
  defp deps do
    [
      # Merkle Tree https://github.com/yosriady/merkle_tree
      # API Docs - Merkle Tree - https://hexdocs.pm/merkle_tree/api-reference.html
      {:merkle_tree, "~> 1.2.0", only: [:dev, :test, :prod]},
      # ABCI Server (Erlang) - https://github.com/KrzysiekJ/abci_server
      # List of ABCI Servers - http://tendermint.readthedocs.io/projects/tools/en/master/ecosystem.html?highlight=server#abci-servers
      {:abci_server, git: "https://github.com/KrzysiekJ/abci_server.git", tag: "v0.4.0"},
      # Ranch is a dependency of ABCI Server (Erlang), which is using the older 
      # version of Ranch 1.3.2, which does not support the latest GNU Make 4
      # Temporarily install Ranch 1.4.0 here until Pull Request https://github.com/KrzysiekJ/abci_server/pull/3
      # is approved and newer version of abci_server is released that uses the latest Ranch version 
      {:ranch, git: "https://github.com/ninenines/ranch.git", tag: "1.4.0"}
    ]
  end
end
