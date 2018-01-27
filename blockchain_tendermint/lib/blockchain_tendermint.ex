defmodule BlockchainTendermint do
  @moduledoc """
  Tendermint Application in Elixir using Erlang ABCI Server

    - Compile in IEx with `c("lib/blockchain_tendermint.ex")`
  """

  @doc """
  Shows Functions available for MerkleTree Library in Elixir.

  ## Examples

      iex> BlockchainTendermint.merkle
      MerkleTree Library in Elixir Information
      [__struct__: 0, __struct__: 1, build: 2, new: 1, new: 2]
  """
  def merkle do
    IO.puts("MerkleTree Library in Elixir Information")
    MerkleTree.__info__(:functions)
  end

  @doc """
  Starts the ABCI Server (Erlang) on given Port and delegates calls to Foo module

    References: 
    - https://github.com/KrzysiekJ/abci_server/blob/master/doc/overview.edoc
    - ABCI Server Docs

  ## Examples

      iex> BlockchainTendermint.start_server
      {:ok, #PID<0.282.0>}
  """
  def start_server do
    {ok, _} = :abci_server.start_listener(BlockchainTendermint, 46658)
  end

  @doc """
  Stops the ABCI Server (Erlang)

  ## Examples

      iex> BlockchainTendermint.stop_server
      :ok
  """
  def stop_server do
    ok = :abci_server.stop_listener(BlockchainTendermint)
  end

  @doc """
  Handle Request to ABCI Server (Erlang)
    - Running `abci-cli test` in Bash Terminal whilst ABCI Server (Erlang)
    is running identifies in IEx Bash Terminal that this Function must be defined.
    After being defined it returns `Passed test: InitChain` 

  ## Examples

      iex> BlockchainTendermint.handle_request
      :ok
  """
  def handle_request(arg) do
    {:reply, "Initialised Chain"}
  end

  def deliver_tx(arg) do
     {:reply, "Deliver Tx"}
  end

  def check_tx(arg) do
     {:reply, "Check Tx"}
  end

  def query(req) do
    { :data, "req: #{req}" }
  end
end
