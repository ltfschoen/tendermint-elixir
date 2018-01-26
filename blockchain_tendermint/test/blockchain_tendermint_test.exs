defmodule BlockchainTendermintTest do
  use ExUnit.Case
  doctest BlockchainTendermint

  test "greets the world" do
    assert BlockchainTendermint.hello() == :world
  end
end
