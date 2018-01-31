defmodule BlockchainTendermintTest do
  use ExUnit.Case
  doctest BlockchainTendermint

  test "verifies that handle_request processes a request" do
    assert BlockchainTendermint.handle_request("") == {:ok, true}
  end
end
