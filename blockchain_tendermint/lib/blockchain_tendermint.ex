defmodule BlockchainTendermint do
  @moduledoc """
  Tendermint Application in Elixir using Erlang ABCI Server

    - Compile in IEx with `c("lib/blockchain_tendermint.ex")`
  """

  @doc """
  Shows Functions available for MerkleTree Library in Elixir.

  ## Non-Doctest Examples (i.e. no iex>)

      BlockchainTendermint.merkle
      MerkleTree Library in Elixir Information
      [__struct__: 0, __struct__: 1, build: 2, new: 1, new: 2]
      {:ok, true}
  """
  def merkle do
    IO.puts("MerkleTree Library in Elixir Information")
    MerkleTree.__info__(:functions)
    {:ok, true}
  end

  @doc """
  Starts the ABCI Server (Erlang) on given Port and delegates calls to BlockchainTendermint module
  that has not yet been implemented

    References: 
    - https://github.com/KrzysiekJ/abci_server/blob/master/doc/overview.edoc
    - ABCI Server Docs

  ## Non-Doctest Examples

      BlockchainTendermint.start_server
      {:ok, #PID<0.282.0>}
  """
  def start_server do
    {ok, _} = :abci_server.start_listener(BlockchainTendermint, 46658)
  end

  @doc """
  Stops the ABCI Server (Erlang)

  ## Non-Doctest Examples

      BlockchainTendermint.stop_server
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

  ## Doctest Examples

      iex> BlockchainTendermint.handle_request("")
      {:ok, true}
  """
  # Default args using \\
  def handle_request(tx_args \\ "sender=a&receiver=b&data=''") do
    # Important Note: Value of `inspect tx_args` is `{:RequestInfo, '0.15.0'}`
    # Temporarily override value of `tx_args` for demonstration purposes only
    IO.puts("handle_request Received Arguments: #{inspect tx_args}")
    tx_args =
      if tx_args === {:RequestInfo, '0.15.0'} || "", do: "sender=a&receiver=b&data=''"
    IO.puts("Elixir ABCI Application Simulation")
    IO.puts("handle_request Override Arguments: #{inspect tx_args}")

    # Send Transaction to Tendermint Node via the `broadcast_tx_commit` Endpoint. 
    # Note: Tendermint Node will run via CheckTx against the Elixir ABCI Application.
    #       If CheckTx passes the Tx is included in the Mempool, Broadcast to Peers, 
    #       and eventually included in a Block
    # Note: `broadcast_tx_commit` returns after transaction committed in block or until timeout.
    #       It returns immediately if the transaction does not pass CheckTx.
    #       The return value includes `check_tx` and `deliver_tx`, which is result of running the 
    #       transaction through those ABCI messages
    # - Option 1 (Preferred) - Use cURL to send ABCI requests from the CLI
    #   i.e. curl -s 'localhost:46658/broadcast_tx_commit?tx="sender=a&receiver=b&data=''"'
    # - Option 2 - Use ABCI-CLI to send ABCI requests from the CLI
    #
    # Note: Transaction with bytes "sender=a&receiver=b&data=''" are stored as Key and 
    #       Value in Merkle Tree

    # Reference: 
    # - https://tendermint.readthedocs.io/en/master/getting-started.html#dummy-a-first-example
    # - http://tendermint.readthedocs.io/projects/tools/en/master/using-tendermint.html#broadcast-api
    
    # Example Response from Sending Transaction:
    # {
    #   "jsonrpc": "2.0",
    #   "id": "",
    #   "result": {
    #     "check_tx": {
    #       "code": 0,
    #       "data": "",
    #       "log": ""
    #     },
    #     "deliver_tx": {
    #       "code": 0,
    #       "data": "",
    #       "log": ""
    #     },
    #     "hash": "2B8EC32BA2579B3B8606E42C06DE2F7AFA2556EF",
    #     "height": 154
    #   }
    # }

    # Simulate Generation of the Genesis Block with Root Hash `root_hash`:
    # - Initial Data Blocks are assigned an Array
    # - Generate Merkle Tree by:
    #   - Creating a Leaf Nodes from Merkle-Hashing (with the Merkle Tree's hash_function) each Data Block
    #   - Recursively Build each Parent Node Hash from Hashing the Concatenation of their immediate 
    #     Child Nodes values until only a Single Root Node remains. Return the Root Node Hash
    #   - Merkle Root Node Hash in the Block Header is the the Hash of all Hashes of all Transactions in a Block 
    #   - Block Header comprises Previous Block Header Merkle Root Hash and Current Block Header Merkle Root Hash
    #   - Verify that Transaction from only the Block Headers and Merkle Tree Root Hash
    # - Reference: https://yos.io/2016/05/19/merkle-trees-in-elixir/

    # Initial Data Blocks
    my_merkle_tree = ["a", "b", "c", "d"]
    # Genesis Block Header - https://github.com/tendermint/tendermint/wiki/Block-Structure#header
    block_0_merkle_tree = MerkleTree.new my_merkle_tree
    block_0_merkle_tree_root = block_0_merkle_tree.root()
    # Genesis Block Merkle Tree Root Hash (LastBlockHash)
    block_0_merkle_tree_root_hash = block_0_merkle_tree_root.value
    IO.puts ("Genesis Block Merkle Tree Root Hash (LastBlockHash): #{block_0_merkle_tree_root_hash}")

    # Genesis Block Merkle Proof
    # - Reference: https://blog.ethereum.org/2015/11/15/merkling-in-ethereum/
    block_0_merkle_proof_chunk_path_branch_0 = MerkleTree.Proof.prove(block_0_merkle_tree, 0)
    block_0_merkle_proof_chunk_path_branch_1 = MerkleTree.Proof.prove(block_0_merkle_tree, 1)
    block_0_merkle_proof_chunk_path_branch_2 = MerkleTree.Proof.prove(block_0_merkle_tree, 2)
    block_0_merkle_proof_chunk_path_branch_3 = MerkleTree.Proof.prove(block_0_merkle_tree, 3)
    block_0_merkle_proof = [
      block_0_merkle_proof_chunk_path_branch_0,
      block_0_merkle_proof_chunk_path_branch_1,
      block_0_merkle_proof_chunk_path_branch_2,
      block_0_merkle_proof_chunk_path_branch_3
    ]

    # Simulate Receipt of Transaction: "sender=a&receiver=b&data=''"
    # - Convert Query String Parameters into Key/Value Pairs
    # FIXME - Should expect "sender='a',..."
    # FIXME - Convert Map to Stringified for `proof=#{block_0_merkle_proof}` 
    #         - https://gist.github.com/ltfschoen/749a5c141fa3536a5e678757d0022c7a
    tx_args_map = String.split(tx_args, ~r/&|=/)
      |> Enum.chunk(2) 
      |> Map.new(fn [k, v] -> {k, v} end)

    # Verify using a Merkle Proof Calculation that the Sender in the `sender` field of the 
    # Transaction was in the Initial Data Blocks. Note: Non-Validators have `seed: ""` in genesis.json
    proven_from_sender_field = Enum.any?(block_0_merkle_proof, fn(block_0_merkle_proof_chunk_path_branch) -> 
      MerkleTree.Proof.proven?(
        {tx_args_map["sender"], 0}, # If `sender=a` then use 0, else if `sender=b` then use 1, etc
        block_0_merkle_tree_root_hash, 
        block_0_merkle_proof_chunk_path_branch
      )
    end)
    # Note: Above returns `true`

    # # Deprecated approach since requires verifying against each individually
    # proven0 = MerkleTree.Proof.proven?(
    #   {tx_args_map["from"], 0}, 
    #   block_0_merkle_tree_root_hash, 
    #   block_0_merkle_proof_chunk_path_branch_0
    # )

    # Verify using a succinct Merkle Proof Calculation that the Recipient in the `to` field of the 
    # Transaction was from the Initial Data Blocks.
    proven_to_recipient_field = Enum.any?(block_0_merkle_proof, fn(block_0_merkle_proof_chunk_path_branch) -> 
      MerkleTree.Proof.proven?(
        {tx_args_map["receiver"], 1}, # If `from=a` then use 0, else if `from=b` then use 1, etc
        block_0_merkle_tree_root_hash, 
        block_0_merkle_proof_chunk_path_branch
      )
    end)
    # Note: Above returns `true`

    # Return whether Tx is Valid
    valid_tx = Enum.any?([
      proven_from_sender_field, 
      proven_to_recipient_field, 
      ], fn(s) -> true end
    )
    IO.puts("Validity of Transaction: #{valid_tx}")

    {:ok, valid_tx}
  end
end
