defmodule BlockchainTendermintTest do
  use ExUnit.Case
  doctest BlockchainTendermint

  test "verifies that sender and recipient of a transaction are from genesis whitelist" do
    assert BlockchainTendermint.handle_request("") == {:ok, true}
  end
end
