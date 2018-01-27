defmodule BlockchainTendermint do
  @moduledoc """
  Documentation for BlockchainTendermint.
  """

  @doc """
  Outputs's `Hello world` everytime.

  ## Examples

      iex> BlockchainTendermint.hello
      :world

  """
  defmodule Foo do
    def bar do
      IO.puts("Hello, World!")
      {:reply, "hi", "bye"}
      # MerkleTree.__info__(:functions)
    end
  end

  def start_server do
    {ok, _} = :abci_server.start_listener(Foo, 46658)
  end

  def stop_server do
    ok = :abci_server.stop_listener(Foo)
  end
end

# https://github.com/KrzysiekJ/abci_server/blob/master/doc/overview.edoc
# {ok, _} = abci_server:start_listener(BlockchainTendermint, 46658).
# ok = abci_server:stop_listener(foo).
