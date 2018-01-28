
---
TENDERMINT-ELIXIR
---

# Table of Contents
  * [Purpose](#chapter-0)
  * [Goals](#chapter-1)
  * [Installation (of Elixir and Tendermint)](#chapter-2)
  * [Initialise and Configure Tendermint](#chapter-3)
  * [Install ABCI-CLI (using Go)](#chapter-3.5)
  * [Setup and Run Elixir ABCI Application and ABCI Server (in IEx REPL)](#chapter-4)
  * [Run Tendermint (Multiple Testnet Nodes)](#chapter-5)
  * [Experimentation with cURL Requests to ABCI Server (Erlang)](#chapter-6)
  * [Experimentation with ABCI-CLI](#chapter-7)
  * [Experimentation with Tendermint (Single Node)](#chapter-8)
  * [Experimentation with ABCI Server (Erlang) Library (in IEx REPL)](#chapter-9)
  * [Experimentation with Merkle Tree Elixir Library (in IEx REPL)](#chapter-10)
  * [Open Source Contributions and Community Questions](#chapter-11)
  * [Troubleshooting and FAQ](#chapter-12)
  * [About Tendermint](#chapter-13)
  * [References](#chapter-14)
  * [Unsorted Notes](#chapter-15)

## Purpose <a id="chapter-0"></a>

* Write an Elixir Application that uses the Tendermint Core (Blockchain Engine) 

## Goals <a id="chapter-1"></a>

* [X] Install Tendermint Core (BFT Consensus) in Go `tendermint --help`
* [X] Install Tendermint ABCI-CLI `abci-cli --help`
* [X] Create Boilerplate Elixir Tendermint Application
* [X] Load [Merkle Tree Elixir Library](https://github.com/yosriady/merkle_tree) with [Mix](https://elixirschool.com/en/lessons/basics/mix/) into Elixir Tendermint Application
* [X] Load [Tendermint ABCI Server (Erlang)](https://github.com/KrzysiekJ/abci_server) with Mix into Elixir Tendermint Application 
* [X] Run Elixir Tendermint Application (optionally using Interactive Elixir (IEx))
  * [X] Start the Tendermint ABCI Server (Erlang)
  * [X] Stop the Tendermint ABCI Server (Erlang)
* [X] Create Shell Script to generate Tendermint Testnet with four (4) Nodes `bash launch_testnet_nodes.sh`
* [.] Write Elixir Tendermint Application that implements the Tendermint ABCI (Application BlockChain Interface. Handle Byzantine Fault Tolerance (BFT) replication of the following State:
  * [.] Root Hash `root_hash` is Pre-Agreed at Genesis and is Generated from the Merkle-Hash of an Array of Whitelisted Participants Addresses 
    * `whitelisted = ["a", "b", "c", "d"]`
  * [.] Verification of the passing the "Ball" Transaction
    * [.] Simulate the Act of passing a "Ball" around with a Transaction comprising `from`, `to`, `to_index`, `proof` fields
    * [.] Verify before passing the "Ball" around using a succinct Merkle Proof Calculation that the Sender of the "Ball" in the `from` field of the Transaction actually held the "Ball" and is a Whitelisted Participants
    * [.] Verify before passing the "Ball" around using a succinct Merkle Proof Calculation that the Recipient of the "Ball" in the `to` field of the Transaction is actually a Whitelisted Participant
    * [ ] Verify before passing the "Ball" around using a succinct Merkle Proof Calculation that the Recipient of the "Ball" is at the Address of the `to_index` field of the Transaction and is proven by the `proof` field of the Transaction, which is a List of Hashes
    * [ ] Verify using a succinct Merkle Proof Calculation that only a Single Whitelisted Participant is holding the "Ball" at a time
  * [ ] Verify using a succinct Merkle Proof Calculation that the Recipient of the "Ball" is the Whitelisted Participant of the `to` field in the Transaction only after successful Validation of the passing the "Ball" Transaction
  * [.] Verify that only the Merke Tree Erlang Library is implemented to perform succinct Merkle Proof Calculations to demonstrate State-Replication https://github.com/yosriady/merkle_tree#usage
    * [.] Verify that State-Replication of the Whitelisted Participant Addressses (`whitelisted`) is only performed on the Merkle Tree `root_hash` and not verbosely
  * [ ] Write Functions to handle calls for `CheckTx` and `DeliverTx` in Elixir
  * [ ] Write Stubs for Tendermint Commits, Inits, BeginBlocks, EndBlocks, and Infos if necessary
  * [ ] Generate Documentation with [ExDoc](https://github.com/elixir-lang/ex_doc) and published on [HexDocs](https://hexdocs.pm)
  * [ ] Release on Github with ZIP file
  * [ ] Publish on [Hex](https://hex.pm/docs/publish)

# Installation (of Elixir and Tendermint)<a id="chapter-2"></a>

## Install Elixir

* Install Elixir - https://elixir-lang.org/install.html
  ```bash
  brew install elixir;
  elixir --version
  ```

## Install Tendermint 

* Tendermint
  * Install Tendermint v0.15.0 - https://github.com/tendermint/tendermint/wiki/Installation
    * Click "Install from Source" https://tendermint.com/downloads
    * Redirects to Install Tendermint https://tendermint.readthedocs.io/en/master/install.html
    * Install Tendermint From Source https://tendermint.readthedocs.io/en/master/install.html#from-source
    * Install GoLang @ https://golang.org/doc/install
    * Add GOPATH https://github.com/golang/go/wiki/SettingGOPATH
    * Add GoLang to $PATH
    * Note: Attempted to use Docker by encountered `shopt` error, as shown in Dockerfile

  ```bash
  go get --help
  go get -u -v github.com/tendermint/tendermint/cmd/tendermint
  tendermint --help
  ```

## Install JSON Pretty Print

* Install JSONPP - https://jmhodges.github.io/jsonpp/
  ```
  brew install jsonpp
  ```

# Initialise and Configure Tendermint <a id="chapter-3"></a>

## Initialise Tendermint

* Create new Private Key `priv_validator.json`, and Genesis File `genesis.json` containing associated Public Key 
  ```bash
  tendermint init
  ```

## Reset Tendermint (if necessary)
  ```bash
  cd ~/.tendermint 
  rm -rf data/
  tendermint unsafe_reset_priv_validator
  ```

## Configure Tendermint

* View Tendermint Directory Root 
  ```bash
  $ ls  ~/.tendermint

  config.toml
  data
  genesis.json
  priv_validator.json
  ```  

* View/Edit TOML Configuration File - https://github.com/tendermint/tendermint/wiki/Configuration
  ```bash
  $ cat ~/.tendermint/config.toml
  # This is a TOML config file.
  # For more information, see https://github.com/toml-lang/toml

  # ABCI Application Socket Address
  proxy_app = "tcp://0.0.0.0:46658"

  # Node Name
  moniker = "<MY_NETWORK_NAME>.local"
  fast_sync = true
  db_backend = "leveldb"
  log_level = "state:info,*:error"

  # Allow Tendermint p2p library to make connections to peers with the same IP address
  # https://tendermint.readthedocs.io/en/master/using-tendermint.html#local-network
  addrbook_strict = false

  [rpc]
  # RPC Server Listening Address
  laddr = "tcp://0.0.0.0:46657"

  [p2p]
  # Peer Listening Address on Tendermint
  laddr = "tcp://0.0.0.0:46656"
  seeds = ""
  ```

* View New Private Key from initialising Tendermint
  ```bash
  $ cat ~/.tendermint/priv_validator.json | python -m json.tool
  {
      "address": "E472...",
      "last_height": 18,
      "last_round": 0,
      "last_signature": {
          "type": "ed25519",
          "data": "B755..."
      },
      "last_signbytes": "7B22...",
      "last_step": 3,
      "priv_key": {
          "type": "ed25519",
          "data": "D11C..."
      },
      "pub_key": {
          "type": "ed25519",
          "data": "8373..."
      }
  }
  ```

* View Genesis File containing Public Key 
  ```bash
  $ cat ~/.tendermint/genesis.json | python -m json.tool
  {
      "app_hash": "",
      "chain_id": "test-chain-gZoesi",
      "genesis_time": "0001-01-01T00:00:00Z",
      "validators": [
          {
              "pub_key": {
                  "type": "ed25519",
                  "data": "8373..."
              },
              "power": 10,
              "name": ""
          }
      ]
  }
  ```

# Install ABCI-CLI (using Go) <a id="chapter-3.5"></a>

* Install ABCI-CLI with Go (includes example Dummy and Counter Apps) - https://tendermint.readthedocs.io/en/master/getting-started.html#dummy-a-first-example
  ```bash
  go get -u github.com/tendermint/abci/cmd/abci-cli;
  abci-cli --help
  ```

# Run Tendermint (Single Tendermint Node) with Example ABCI Applications <a id="chapter-4"></a>

## Run Tendermint (Single Tendermint Node) with Example ABCI Applications (i.e. "Dummy" (GoLang))

* Start Tendermint Single-Node Blockchain and Compile in-progress ABCI Application written in GoLang (i.e. Dummy App https://github.com/tendermint/abci)
  ```bash
  $ tendermint node --proxy_app=dummy

  I[01-22|21:35:03.283] Executed block                               module=state height=1 validTxs=0 invalidTxs=0
  I[01-22|21:35:03.283] Committed state                              module=state height=1 txs=0 appHash=
  I[01-22|21:35:04.295] Executed block                               module=state height=2 validTxs=0 invalidTxs=0
  I[01-22|21:35:04.295] Committed state                              module=state height=2 txs=0 appHash=
  ```

* Review Example Application built with ABCI Server - https://github.com/KrzysiekJ/abci_counter

# Setup and Run Elixir ABCI Application and ABCI Server (Erlang) (in IEx REPL) <a id="chapter-5"></a>

## Update GNU Make

* Upgrade to GNU Make 4 or later (macOS pre-installed with GNU Make 3) https://erlang.mk/guide/installation.html
  ```bash
  brew install erlang git;
  brew install make --with-default-names;
  ```

## Switch Directory (to the Elixir ABCI Application)

* Change into App Directory.
  ```bash
  cd blockchain_tendermint;
  ```

## Configure Mix Dependencies. Add ABCI Server (Erlang) (to the Elixir ABCI Application)

* Add ABCI Server (Erlang) to mix.exs. [Choose a Release Tag](https://github.com/KrzysiekJ/abci_server/tags) 
  ```elixir
  defp deps do
    [
      # ABCI Server (Erlang) - https://github.com/KrzysiekJ/abci_server
      # Tendermint List of ABCI Servers - http://tendermint.readthedocs.io/projects/tools/en/master/ecosystem.html?highlight=server#abci-servers
      {:abci_server, git: "https://github.com/KrzysiekJ/abci_server.git", tag: "v0.4.0"}
    ]
  end
  ```

## Install Mix Dependencies (for the Elixir ABCI Application)

* Fetch Mix Dependencies defined in mix.exs
  ```bash
  mix deps.get
  ```

## Show Documentation for ABCI Server (Erlang)

* Documentation Generation. Open Documentation in Web Browser
  ```bash
  cd deps/abci_server/ && make docs && open doc/index.html && cd ../../
  ```

## Compile Elixir ABCI Application with Mix

* Compile Mix Project into _build/ Directory
  ```bash
  MIX_ENV=dev mix compile
  ```

## Run Elixir ABCI Application in Interactive Elixir (IEx) REPL to Demonstrate Verification of Transaction Sender/Recipient

* Interactive Elixir (REPL) within context of Elixir App and dependencies injected into IEx runtime
  ```bash
  iex -S mix
  ```

  ```elixir
  c("lib/blockchain_tendermint.ex")
  BlockchainTendermint.start_server
  ```

* Run Tendermint Node 
  ```
  tendermint node
  ```

* Send cURL Request to ABCI Server endpoint.
  ```
  curl -s 'localhost:46658/broadcast_tx_commit?tx="from=___&to=___&to_index=___&proof=___"'
  ```

* View Logs from ABCI Server in IEx Terminal Window. Shows Outputs of `handle_request` function in Elixir ABCI App
  ```
  iex(1)> BlockchainTendermint.start_server
  {:ok, #PID<0.168.0>}
  iex(2)> Processing Transaction
  58c89d709329eb37285837b042ab6ff72c7c8f74de0446b091b6a0131c102cfd
  Validity of Transaction: true

  20:32:18.499 [error] GenServer #PID<0.176.0> terminating
  ** (FunctionClauseError) no function clause matching in :abci.e_msg_ResponseInfo/3
      ...
  Last message: {:tcp, #Port<0.5191>, <<1, 10, 34, 8, 10, 6, 48, 46, 49, 53, 46, 48, 1, 2, 26, 0>>}
  State: {:state, #Port<0.5191>, :ranch_tcp, "", BlockchainTendermint}
  
  20:32:18.502 [error] Ranch listener BlockchainTendermint had connection process started with :abci_server:start_link/4 at #PID<0.176.0> exit with reason: ...
  ```

* Stop Server
  ```elixir
  BlockchainTendermint.stop_server
  ```

# Run Mix Unit Tests and Doctests <a id="chapter-4.5"></a>

* Run Unit Tests and Doctests with Mix
  ```bash
  mix test
  ```

# Run Tendermint (Multiple Testnet Nodes) <a id="chapter-5"></a>

* Launch Testnet Nodes (4 OFF) (in separate Terminal Tabs using Shell Script)
  ```bash
  $ bash launch_testnet_nodes.sh
  Tendermint Testnet Location: /Users/Ls/code/blockchain/tendermint-elixir/mytestnet
  Loading Nodes: mach0, mach1, mach2, mach3
  Loading Seeds: 0.0.0.0:46656,0.0.0.0:46666,0.0.0.0:46676,0.0.0.0:46686
  Successfully initialized 4 node directories
  ```
  * Troubleshooting: If nothing appears in each of the separate Terminal Tabs then in restart the server in IEx with:
    ```elixir
    k = BlockchainTendermint.stop_server
    {ok, _} = BlockchainTendermint.start_server
    ```

    * Example output in each separate Terminal Tab

      ```bash
      E[01-27|23:38:17.914] Stopping abci.socketClient for error: EOF    module=abci-client connection=query
      E[01-27|23:38:29.069] Stopping abci.socketClient for error: EOF    module=abci-client connection=mempool
      E[01-27|23:38:29.069] Stopping abci.socketClient for error: EOF    module=abci-client connection=consensus

      E[01-27|23:38:29.068] Stopping abci.socketClient for error: read tcp 127.0.0.1:63711->127.0.0.1:46658: read: connection reset by peer module=abci-client connection=query
      E[01-27|23:38:29.068] Stopping abci.socketClient for error: read tcp 127.0.0.1:63713->127.0.0.1:46658: read: connection reset by peer module=abci-client connection=consensus
      E[01-27|23:38:29.069] Stopping abci.socketClient for error: read tcp 127.0.0.1:63712->127.0.0.1:46658: read: connection reset by peer module=abci-client connection=mempool
      ```

  * **UNRESOLVED**

* Optional Alternative Deployment 
  * Kubernetes - https://github.com/tendermint/tools/tree/master/mintnet-kubernetes
    * **TODO**

# Experimentation with cURL Requests to ABCI Server (Erlang) <a id="chapter-6"></a>

* Show all available API endpoints by going to http://0.0.0.0:46658/

  * **UNRESOLVED**

* Send Request to ABCI Server endpoint. Note: Must use `0.0.0.0` NOT `localhost`
  ```
  curl -v '0.0.0.0:46658/status' | jsonpp | grep app_hash
    *   Trying 0.0.0.0...
    * TCP_NODELAY set
    * Connected to 0.0.0.0 (0.0.0.0) port 46658 (#0)
    > GET /status HTTP/1.1
    > Host: 0.0.0.0:46658
    > User-Agent: curl/7.57.0
    > Accept: */*
    > 
  ```

  * **UNRESOLVED**

# Experimentation with ABCI-CLI <a id="chapter-7"></a>

**UNRESOLVED**

* Experiment with ABCI-CLI (from separate Bash Terminal Tab after starting ABCI Server in IEx)
  * CheckTx
    ```bash
    abci-cli check_tx "0x00" --address tcp://0.0.0.0:46658 --abci "socket" --log_level "debug" --verbose
    ```

  * Echo
    ```bash
    abci-cli echo "Hello" --address tcp://0.0.0.0:46658 --abci "socket" --log_level "debug" --verbose
    ```

  * DeliverTx
    ```bash
    abci-cli deliver_tx "0x00" --address tcp://0.0.0.0:46658 --abci "socket" --log_level "debug" --verbose
    ```

  * Query
    ```bash
    abci-cli query "0x00" --address tcp://0.0.0.0:46658 --abci "socket" --log_level "debug" --verbose
    ```

# Experimentation with Tendermint (Single Node) <a id="chapter-8"></a>

* Run Tendermint Core (blockchain engine) Node
  ```bash
  tendermint init;
  tendermint unsafe_reset_all;
  tendermint node --help;
  tendermint node \
    --abci "socket" \
    --consensus.create_empty_blocks true \
    --fast_sync true \
    --moniker "LS.local" \
    --p2p.laddr "tcp://0.0.0.0:46656" \
    --p2p.pex true \
    --p2p.seeds "tcp://127.0.0.1:46656, tcp://127.0.0.1:46666, tcp://127.0.0.1:46676, tcp://127.0.0.1:46686" \
    --p2p.skip_upnp false \
    --proxy_app "tcp://127.0.0.1:46658" \
    --rpc.laddr "tcp://0.0.0.0:46657" \
    --rpc.unsafe true \
    --home "/Users/Ls/.tendermint" \
    --log_level "state:info,*:error" \
    --trace true
  ```

# Experimentation with ABCI Server (Erlang) Library (in IEx REPL) <a id="chapter-9"></a>

* Run IEx
  ```bash
  iex -S mix
  ```
    
## Experiment with ABCI Server in IEx

* Reference: Loading an Erlang Library into Elixir - https://elixirschool.com/en/lessons/advanced/erlang/

* Important Note: `__info__/1` is an Elixir thing the compiler adds, you probably want `module_info/1` which is the erlang equivalent - https://elixir-lang.slack.com/archives/C03EPRA3B/p1517018221000028

* Show ABCI Server Module Information. Start ABCI Server. Stop ABCI Server
  ```elixir
  iex> :abci_server.module_info  
  [
    module: :abci_server,
    exports: [
      start_link: 4,
      start_listener: 2,
      child_spec: 2,
      stop_listener: 1,
      init: 1,
      handle_call: 3,
      handle_cast: 2,
      handle_info: 2,
      terminate: 2,
      code_change: 3,
      module_info: 0,
      module_info: 1
    ],
    attributes: [
      vsn: [86973587470476204871336807197797490126],
      behaviour: [:gen_server],
      behaviour: [:ranch_protocol]
    ],
    compile: [
      options: [
        :debug_info,
        {:i,
        '/Users/Ls/code/blockchain/tendermint-elixir/blockchain_tendermint/deps/abci_server/include'},
        :warn_obsolete_guard,
        :warn_shadow_vars,
        :warn_export_vars
      ],
      version: '7.1.4',
      source: '/Users/Ls/code/blockchain/tendermint-elixir/blockchain_tendermint/deps/abci_server/src/abci_server.erl'
    ],
    native: false,
    md5: <<65, 110, ..., 206>>
  ]

  iex>  defmodule Foo do             
          def bar() do               
            IO.puts("Hello, World!") 
          end
        end

  iex> {ok, _} = :abci_server.start_listener(Foo, 46658)
  {:ok, #PID<0.181.0>}
  ```

* Integration Tests run against the ABCI Server (Erlang) (separate Bash Terminal Tab) https://github.com/tendermint/abci#tools
  ```bash
  abci-cli test
  ```

  * View Output (in the Bash Terminal Tab running IEx)
    ```elixir
    iex> 
    14:27:53.961 [error] GenServer #PID<0.242.0> terminating
    ** (UndefinedFunctionError) function Foo.handle_request/1 is undefined (module Foo is not available)
        Foo.handle_request(
          { 
            :RequestInitChain, 
            [ 
              { :Validator, <<1, 229, ..., 36>>, 1647107211121726315 }, 
              { :Validator, <<1, 243, ..., 78>>, 8186817011543816184 }, 
              { :Validator, <<1, 102, ..., 16>>, 7982159435569315414 }, 
              { :Validator, <<1, 135, ..., 64>>, 2846252370576207682 }, 
              { :Validator, <<1, 241,..., 159>>, 637770835807807961 }, 
              { :Validator, <<1, 16, ..., 76>>, 4097788002864909056 }, 
              { :Validator, <<1, 152, ..., 70>>, 8116718250853054711 }, 
              { :Validator, <<1, 19, ..., 246>>, 3891949616163017026 }, 
              { :Validator, <<1, 179, ..., 254>>, 7045591847215797995 }, 
              { :Validator, <<1, 189, ..., 80>>, 4226073179895220771 }
            ]
          }
        )
        (abci_server) src/abci_server.erl:117: :abci_server.handle_requests/2
        (abci_server) src/abci_server.erl:83: :abci_server.handle_info/2
        (stdlib) gen_server.erl:616: :gen_server.try_dispatch/4
        (stdlib) gen_server.erl:686: :gen_server.handle_msg/6
        (stdlib) proc_lib.erl:247: :proc_lib.init_p_do_apply/3
    Last message: { :tcp, #Port<0.5297>, <<2, 1, ..., 148, ...>> }
    State:        { :state, #Port<0.5297>, :ranch_tcp, "", Foo}
    
    14:27:53.965 [error] Ranch listener Foo had connection process started with :abci_server:start_link/4 at #PID<0.242.0> exit with reason: 
    { :undef, 
      [ 
        { 
          Foo, 
          :handle_request, [ 
            RequestInitChain: [ 
              { :Validator, <<1, 229, ..., 36>>, 1647107211121726315 }, 
              { :Validator, <<1, 189, ..., 112, ...>>, 4226073179895220771 }
            ]
          ], 
          []
        }, 
        { 
          :abci_server, 
          :handle_requests, 
          2, 
          [file: 'src/abci_server.erl', line: 117]
        }, 
        {
          :abci_server, 
          :handle_info, 
          2, 
          [file: 'src/abci_server.erl', line: 83]
        }, 
        {
          :gen_server, 
          :try_dispatch, 
          4,
          [file: 'gen_server.erl', line: 616]
        }, 
        {
          :gen_server, 
          :handle_msg, 
          6, 
          [file: 'gen_server.erl', line: 686]
        }, 
        {
          :proc_lib, 
          :init_p_do_apply, 
          3, 
          [file: 'proc_lib.erl', line: 247]
        }
      ]
    }
    ```

* Update Elixir App to define `handle_request` Handle Request. Re-run the following in a separete Bash Terminal whilst ABCI Server (Erlang) is running and it will return `Passed test: InitChain`. 
  * Reference: Sample ABCI Counter App https://github.com/KrzysiekJ/abci_counter/tree/master/src
  ```bash
  abci-cli test
  ```

# Experimentation with Merkle Tree Elixir Library (in IEx REPL) <a id="chapter-10"></a>

* Merkle Tree Library
  * [MerkleTree Module Example](https://hexdocs.pm/merkle_tree/MerkleTree.html)
    * Create a Merkle Tree (given a number of string Blocks, and optional Cryptographic Hash Function):
      * Each non-leaf node is labelled with the hash of the labels or values (for leafs) of its child nodes
      * Allows efficent and secure verification of the contents of large data structures
      * Default Hash Function is `:sha256`
      * API Docs Reference: https://hexdocs.pm/merkle_tree/MerkleTree.html#new/2
      * Reference: 
        * Merkle Trees in Elixir Blogpost: https://yos.io/2016/05/19/merkle-trees-in-elixir/

    ```elixir
    iex> MerkleTree.__info__(:functions)
    [__struct__: 0, __struct__: 1, build: 2, new: 1, new: 2]
    iex> mt = MerkleTree.new ['a', 'b', 'c', 'd']
    %MerkleTree{
      blocks: ['a', 'b', 'c', 'd'], 
      hash_function: &MerkleTree.Crypto.sha256/1,
      root: 
        %MerkleTree.Node {
          children: [ 
            %MerkleTree.Node {
              children: [ 
                %MerkleTree.Node {
                  children: [],
                  value: "ca978112ca1bbdcafac231b39a23dc4da786eff8147c4e72b9807785afee48bb"
                },
                %MerkleTree.Node {
                  children: [], 
                  value: "3e23e8160039594a33894f6564e1b1348bbd7a0088d42c4acb73eeaed59c009d"
                }
              ],
              value: "62af5c3cb8da3e4f25061e829ebeea5c7513c54949115b1acc225930a90154da"
            },
            %MerkleTree.Node {
              children: [
                %MerkleTree.Node {
                  children: [], 
                  value: "2e7d2c03a9507ae265ecf5b5356885a53393a2029d241394997265a1a25aefc6"
                },
                %MerkleTree.Node {
                  children: [], 
                  value: "18ac3e7343f016890c510e93f935261169d9e3f565436429830faf0934f4f8e4"}
              ],
              value: "d3a0f1c792ccf7f1708d5422696263e35755a86917ea76ef9242bd4a8cf4891a"
            }
          ],
          value: "58c89d709329eb37285837b042ab6ff72c7c8f74de0446b091b6a0131c102cfd"
        }
    }
    $ mt.blocks()
    ['a', 'b', 'c', 'd'] 
    $ mt.hash_function()
    &MerkleTree.Crypto.sha256/1
    $ mt.root()
    ...
    ```

  * [MerkleTree.Proof Module Example](https://hexdocs.pm/merkle_tree/MerkleTree.Proof.html) (requires merkle_tree >1.2.0)
    * Generate and Verify Merkle Proofs
    ```elixir
    iex> MerkleTree.Proof.__info__(:functions)           
    [__struct__: 0, __struct__: 1, prove: 2, proven?: 3]
    iex> proof1 = MerkleTree.Proof.prove(mt, 1)
    iex> proven1 = MerkleTree.Proof.proven?({"b", 1}, "58c89d709329eb37285837b042ab6ff72c7c8f74de0446b091b6a0131c102cfd", proof1)
    true

    iex> proof3 = MerkleTree.Proof.prove(mt, 3)                                              
    %MerkleTree.Proof{          
      hash_function: &MerkleTree.Crypto.sha256/1,
      hashes: ["62af5c3cb8da3e4f25061e829ebeea5c7513c54949115b1acc225930a90154da",
      "2e7d2c03a9507ae265ecf5b5356885a53393a2029d241394997265a1a25aefc6"]
    }
    iex> proven3 = MerkleTree.Proof.proven?({"d", 3}, "58c89d709329eb37285837b042ab6ff72c7c8f74de0446b091b6a0131c102cfd", proof3)
    true
    ```

  * [MerkleTree.Crypto Module Example](https://hexdocs.pm/merkle_tree/MerkleTree.Crypto.html)
    ```elixir
    iex> MerkleTree.Crypto.__info__(:functions) 
    [hash: 2, sha256: 1]
    iex> MerkleTree.Crypto.hash("tendermint", :sha256) 
  "f6c3848fc2ab9188dd2c563828019be7cee4e269f5438c19f5173f79898e9ee6"
    iex> MerkleTree.Crypto.hash("tendermint", :md5)   
  "bc93700bdf1d47ad28654ad93611941f"
    iex> MerkleTree.Crypto.sha256("tendermint")    
  "f6c3848fc2ab9188dd2c563828019be7cee4e269f5438c19f5173f79898e9ee6"
    ```

# Open Source Contributions and Community Questions <a id="chapter-11"></a>

* Merkle Tree
  * Pull Request - https://github.com/yosriady/merkle_tree/pull/8
  * Issue - https://github.com/yosriady/merkle_tree/issues/9

* ABCI Server
  * Pull Request - https://github.com/KrzysiekJ/abci_server/pull/3
  * Issues:
    * https://github.com/KrzysiekJ/abci_server/issues/4
    * https://github.com/KrzysiekJ/abci_server/issues/5

  * Questions
    * Elixir Slack 
      * https://elixir-lang.slack.com/archives/C03EPRA3B/p1517016786000068

# Troubleshooting and FAQ <a id="chapter-12"></a>

* Problem: `erlang.mk:26: Please upgrade to GNU Make 4 or later: https://erlang.mk/guide/installation.html`
  * Solution:
    * Check Make and GMake installation directories
      ```
      $ which -a make;
      /usr/bin/make
      $ which -a gmake;
      /usr/local/bin/gmake
      ```

    * Add to Bash Profile
      ```
      export PATH="/usr/local/bin/make:$PATH"
      export PATH="/usr/local/opt/make/libexec/gnubin:$PATH"
      ```
    * Reset Bash Profile
      ```
      source ~/.bash_profile
      ```
    * Create Symlink between version of GNU Make 4 in PATH and where it is installed (instead of default macOS GNU Make 3)
      ```
      ln -s /usr/local/bin/gmake /usr/local/bin/make
      ```
    * Check PATH of Make has changed
      ```
      $ which make
      /usr/local/bin/make
      ```

* Problem: `** (Mix) Could not start application ranch: could not find application file: ranch.app`
  * Solved: See Issue raised https://github.com/KrzysiekJ/abci_server/issues/4

* Problem: Unable to communicate with Elixir ABCI App. After running ABCI Server, when I try and connect with `tendermint node`, it gives the following error, which is not listed on the Tendermint how to read logs webpage -
https://tendermint.readthedocs.io/en/master/how-to-read-logs.html
  ```
  E[01-27|05:47:23.729] Stopping abci.socketClient for error: EOF    module=abci-client connection=query
  ```
  * **UNRESOLVED**
    * https://matrix.to/#/!vIMgGaMqkLIWPCZvPF:matrix.org/$151705250910696925POLba:matrix.org
    * https://github.com/tendermint/tendermint/issues/1166

* Problem: Tendermint Testnet Node flags moniker and seed do not overwrite as expected
  * **UNRESOLVED**
    * https://github.com/tendermint/tendermint/issues/1167

# About Tendermint <a id="chapter-13"></a>

* Tendermint

  * Background - https://blockchainhub.net/blog/blog/scaling-ethereum-2/

  * Diagrams
    * Tendermint in a (technical) nutshell - https://github.com/devcorn/hackatom/blob/master/tminfo.pdf

  * TendermintCore (BFT "consensus engine" Protocol that is mostly Asynchronous that uses a Simple State Machine https://tendermint.readthedocs.io/en/master/introduction.html#consensus-overview, and that communicates with an Application via TSP socket protocol that satisfies the ABCI)
    * About
      * Tendermint Core
        * Definition - a general purpose blockchain data structure (transactions batched in blocks where each block contains a cryptographic hash of the previous block, and the blocks form a chain) to replicate your Application on distributed systems (many machines) to provide fault tolerance
          * Secure Replication - Byzantine Fault Tolerant (BFT) since it still works when up to 1/3 of machines fail (from causes including hacking and malicious attacks)
          * Consistent Replication - all non-faulty machines may see same Transaction Log and computes same State
          * Consensus Engine - sharing Blocks and Transactions between Nodes to ensure recorded on all machines in same immutable order (blockchain)
          * Hosts Arbitrary States - may be used as plug-and-play replacement for consensus engines of other blockchain software (i.e. run any programming language implementation of Ethereum as an ABCI application using Tendermint consensus, i.e. Ethermint, Cosmos network)

    * Byzantine Fault Tolerant (BFT) Consensus engine
      * Note: Non Proof-of-Work (PoW) system
      * Reference: https://github.com/tendermint/tendermint/wiki/Byzantine-Consensus-Algorithm
        * Summary
          * Block Data Structure - https://github.com/tendermint/tendermint/wiki/Block-Structure
            * `Header` - chain info and Last State
              * `ChainId` (string): name of the Blockchain, e.g. "tendermint"
              * `Height` (int): sequential Block Number starting with 1
              * `Time` (time): local time of the Proposer of this Block
              * `LastBlockHash` ([]byte): Block Hash of the Previous Block at `Height - 1`
              * `LastBlockPartsetHeader` (PartSetHeader): Partset Header of the Previous Block
              * `StateHash` ([]byte): State Hash of the State after processing this Block
                * `StateHash` is a hash derived from a encoding the State's Fields (i.e. `BondedValidators`, `UnbondingValidators`, `Accounts`, `ValidatorInfos`, and `NameRegistry`), using a [Simple Tree (Binary Tree)](https://github.com/tendermint/tendermint/wiki/Merkle-Trees#simple-tree-with-dictionaries) to merkelise a dictionary list of KV Pair structs.
                * `StateHash` is recursively included in the block `Header` and indirectly into the `BlockHash`

            * `Data` - Transactions of the Block that are any sequence of Bytes comprising:
              * `Txs` ([]`Tx`): list of Transactions. 
              Note: [ABCI Applications](https://github.com/tendermint/abci) (previuosly known as TMSP) may Accept or Reject a Tx
            * `LastCommit` - Comprises `Precommit` Signatures of the Previous Block 
              * `Precommits` ([]`Vote`): confirms that Consensus Decided for the Last Block was performed by over 2/3 (i.e. +2/3) of valid Voting Participants
                * `Vote`
                  * `Height` (int): Block Height being Decided on
                  * `Round` (int): Consensus Round number (starting with 0)
                  * `Type` (byte): Vote Type, either:
                    * `Prevote` or `Precommit` - [Vote Type](https://github.com/tendermint/tendermint/wiki/Block-Structure#vote) to Broadcast
                      i.e. `"type": 2`
                    * Note: Proof-of-Lock-Change (PoLC) is the Set of +2/3 `Prevote`'s for a Block, or `<nil>` at Node `(H, R)`
                  * `BlockHash` ([]byte): 
                    * Block Hash of a valid Block, or nil.
                    * Blockhash is a hash derived from a encoding the Block Header fields using a [Simple Tree (Binary Tree)](https://github.com/tendermint/tendermint/wiki/Merkle-Trees#simple-tree-with-dictionaries) to merkelise a dictionary list of KV Pair structs
                  * `BlockPartsetHeader` (PartSetHeader):
                    * PartSet Header, or x0000 if Block Hash is nil
                    * PartSet (inspired by LibSwift project) is used to propagate a Large File over a Gossip Protocol Network (i.e. multicast a message to all nodes in a network, where each node only sends the message to a few of the nodes)
                    * PartSet splits a Byteslice of Data (a Part) into a Transmission Parts List. Compute the Merke Root Hash of the Transmission Parts List. Verify that a Part is legitimately a Part of the Data by using the Merkle Root Hash of the Transmission Parts List prior to Forwarding the Part to other Peers (even before other Parts are known)  
                      i.e. `{ "hash": "XYZ", "total": 123 }`
                    * Example code: https://github.com/tendermint/tendermint/wiki/Block-Structure#commit
                  * `Signature` (Signature): `Signature` field of Vote's Transaction
                    * `sign-bytes`: JSON stringified (ordered) encoding (excluding the `Signature`) of Vote's Transaction
                      i.e. Example Precommit Vote:
                      `{ "chain_id": "tendermint","vote": { ... } }`

          * Consensus Process (State Machine) - https://tendermint.readthedocs.io/en/master/introduction.html#consensus-overview 
            * Deciding Next Block (at each Block Height `H`)
              * Rounds (Round-based Protocol) - each Round has a State Machine `RoundStep` representation (aka "Step") comprising Optimally 3x Steps + 2x Special Steps:
                * Round (sequence)
                  * Step 1: `Propose (H, R)` 
                    * Prerequisite, either:
                      * `CommitTime` + `timeoutCommit` (after `NewHeight` committed) OR
                      * `timeoutPrecommit`
                    * Start:
                      * Proposer (designated) proposes a Block at `(H, R)`
                    * End: 
                      * After `timeoutProposer` -> Step 2
                      * After `PoLC Round` receipt of Proposal Block and all Prevotes -> Step 2
                      * After "Common Exit Conditions"
                        * QUESTION - HOW? ALL THE COMMON EXIT CONDITIONS ARE POST- STEP 1
                          * https://matrix.to/#/!vIMgGaMqkLIWPCZvPF:matrix.org/$15167017365754249pwRYF:matrix.org
                  * Step 2: `Prevote (H, R)`
                    * Start:
                      * Validators broadcast their Prevote Vote
                    * Situations:
                      * Unlocking happens when Validators that have been Locked on a Block since `LastLockRound`
                      who also have a `PoLC` for something else at `PoLC-Round` where `LastLockRound < PoLC-Round < R`
                      * Prevote for a Block happens when a Validator is still Locked on a Block
                      * Prevote for a Proposed Block from `Propose (H, R)` happens when it is Valid
                      * Prevote of `<nil>` happens for a Proposed Block that is Invalid or received late
                    * End:
                      * After +2/3 Prevotes for a specific Block or `<nil>` -> Step 3
                      * After `timeoutPrevote` after receiving any +2/3 Prevotes -> Step 3
                      * After "Common Exit Conditions"
                  * Step 3: `Precommit (H, R)` after +2/3 Precommits for Block found
                    * Start:
                      * Validators broadcast their Precommit Vote
                    * Situation:
                      * Re-Locks / Changes Lock and Precommits Block `B` and Sets `LastLockRound = R` when Validator has PoLC `(H, R)` for specific Block `B`
                      * Unlocks and Precommits `<nil>` (i.e. obtained +2/3 Prevotes and waited but did not see PoLC for the Round) when Validator has PoLC at `(H, R)` for `<nil>`
                      * Lock remains and Precommits `<nil>` otherwise
                    * End:
                      * After +2/3 Precommits for `<nil>` -> Step 1 `Propose (H, R + 1)`
                      * After `timeoutPrecommit` after receiving any +2/3 Precommits -> Step 1 `Propose (H, R + 1)`
                      * After "Common Exit Conditions"
                * Special Step A: `Commit (H)` by:
                  * Setting `CommitTime = now`
                  * Waiting to receive Block and then Stage, Save, and Commit the Block -> Step B `NewHeight (H + 1)`
                * Special Step B: `NewHeight (H)`
                  * Move `Precommits` to `LastCommit`
                  * Increment Block Height
                  * Set `StartTime = CommitTime + timeoutCommit`
                  * Wait until `StartTime` to receive straggling commits -> Step 1 `Propose (H, 0)`
                    i.e. `NewHeight -> (Propose -> Prevote -> Precommit) + -> Commit -> NewHeight ->`
                * Note: See Diagram: https://github.com/tendermint/tendermint/wiki/Byzantine-Consensus-Algorithm
              * Note: Multiple Rounds may be required to due to:
                * Problems
                  * Proposer (designated) was not online
                  * Proposer (designated) had proposed an Invalid Block
                  * Proposer (designated) had proposed a Valid Block that did not propogate in time
                  * Proposer (designated) had proposed a Valid Block but +2/3 of its Prevotes were not received in time (i.e. at least 1x Validator may have voted `<nil>` or performed a malicious votes) so there were Insufficient Validator Nodes when the Precommit step was reached
                  * Proposer (designated) had proposed a Valid Block and +2/3 of its Prevotes were received for sufficent nodes, but +2/3 of the Precommits for the Proposed Block were not received for sufficient Validator nodes.
                * Solutions
                  * Subsequent Round and Proposer (designated)
                  * Increasing Round parameters (i.e. Timeout) for successive rounds

          * Proposal 
            * Signed & Published by Proposer (designated) at each Round
            * Proposal at Node `(H, R)` comprises:
              * Block
              * Optional PoLC Round (which is less than `R`), included if Proposer is aware of one, and provides a hint to the network to allow "unlocking" of Nodes when safe to ensure "Proof of Liveness"

          * Proposer (NOT Validators)
            * Selected in proportion to their Voting Power (using round robin selection algorithm)
            * Reference: [Code](https://github.com/tendermint/tendermint/blob/develop/types/validator_set.go#L49)

          * Nodes - optionally connected in the network, are at a given:
            * Height `H` - Block Height being decided upon
            * Round `R` - Consensus Round number (starting from 0)
            * Step `S`
              * i.e. `(H, R, S)`
          
          * Peers - are Nodes that are directly connected to a Node

          * `Channel` (Throttled information)
            * `Connection` - between 2x Nodes

          * Epidemic Gossip Protocol - implemented by some Channels to update Peers on latest State of Consensus 
            * Nodes use PartSet algorithm (LibSwift inspired) to gossip/broadcast Parts (split Data) across the network for the current Round decision for a Proposed Block by a Proposer
            * Nodes gossip Prevote/Precommit Votes to enable Other Nodes to progress forward
              i.e. Node A (ahead of Node B) may send Node B Prevotes/Precommits for Node B's current/future Round
            * Nodes gossip Prevotes for Proposed Proof-of-Lock-Change (PoLC) Round (i.e. requires Set of +2/3 `Prevote`'s for a Block, or `<nil>` at Node `(H, R)`
            * Nodes gossip Block Commits for Older Blocks to Other Nodes that are lagging with a lower Blockchain Height
            * Nodes gossip `HasVote` messages opportunistically to hint to Peers what Votes they have
            * Nodes broadcast to all Peers their current State

          * Gossip Protocol Participants are "Validators"
            * Validators
              * Validators take turns as Proposer (delegate) Blocks containing Transactions and Voting on Blocks to be Committed on-chain at Block Height
              * Validators Vote to move to Next Round after waiting a Timeout interval (the only Synchronous aspect of the Protocol) to receive a complete Proposal Block from the Proposer 
              * Validators only progress after hearing from 2/3+ of the Validator Set

            * Blocks
              * Failure of a Block Commit causes the Protocol to move to the Next Round with a New Validator as Proposer (delegate) to propose the Next Block Height
              * Tendermint uses same mechanism for Block Commits as it does for Skipping to Next Round
              * Tendermint guarantees Safety without Validators ever committing a Block Commit that conflicts at the same Block Height on the assumption that 1/3- of Validators are BFT by using "Locking" rules that modulate the paths that may be followed in the Consensus Flow Diagram

            * Block Commit Failure
              * Causes
                * Proposer (delegate) may be Offline
                * Network may be slow
              * Solutions
                * Skip a Validator
            
            * Voting Stages required for Block Commit
              * Prevote 
                * Block Committed when 2/3+ of Validators Precommit for the same Block in the same Round.
                * "Polka" occurs when 2/3+ of Validators Prevote for the same Block
              * Precommit
                * Precommitted Blocks by a Validator are "Locked" on the Block and then must Prevote for the Block it is "Locked" on
                * Validators may only "Unlock" and Precommit for a New Block if there is a "Polka" for the New Block in a later Round
                * Precommits must be justified by a "Polka" in the same Round

            * Nodes
              * Non-Active Validators 
                * No Validator Private Key
                * Relays to Peers any Consensus Process information (i.e. meta-data, Proposals, Blocks, and Votes)
                * State (Current `H`, `R`, `S`)
                * Enable other Nodes to progress forward
              * Active Validator (aka "Validator-Node")
                * Validator Private Keys
                * Signs Votes
                * State (Current `H`, `R`, `S`)
                * Enable other Nodes to progress forward

            * Stake
              * Validator "Weight" varies in the Consensys Protocol of some systems
                * Voting Power Proportion may not be uniformly distributed across individual Validators 
              * Tendermint allows for creation of Proof-of-Stake systems through definition of a native Currency that denominates Voting Power. Cosmos Network is designed using this PoS mechanism across an array of cryptocurrencies implemented as ABCI Applications
                * Validators "bond" their Voting Power Currency holdings in a security deposit that may be destroyed if found to misbehave in the Consensys Protocol, which quantifies an economic security element whereby the Cost of Violating the assumption that 2/3- of Voting Power is Byzantine 

          * Proofs

            * Proof of Safety
              * Assuming -1/3 (less than 1/3) of Validators voting power are Byzantine
              * Validators may commit Block `B` at Round `R` after observing +2/3 (over 2/3) of Precommits at Round `R`
              * Unlikely for 1/3+ (over 1/3) of Honest Nodes Locked at Round `R' > R` to remain so until they observe PoLC at `R' > R`
              * -2/3 (less than 2/3) are available to Vote for anything other than Block `B`
              since 1/3+ (over 1/3) are Locked and Honest Nodes
              * CONFUSING?
            
            * Proof of Liveness
              * Assuming 1/3+ (over 1/3) of Validators are Locked on 2x different Blocks from different Rounds
              then a Proposer's `PoLC-Round` will Unlock Nodes that were Locked in previous Rounds
              * Proposer (designated) will become aware of a PoLC in a subsequent Round 
              * `timeoutProposalR` increments with Round `R` whilst Proposal size is capped, so network eventually is able to fully gossip the whole Proposal (both Block and PoLC)

            * TODO
              * Proof of Fork Accountability - https://github.com/tendermint/tendermint/wiki/Byzantine-Consensus-Algorithm#proof-of-fork-accountability
              
              * Alternative Algorithm - https://github.com/tendermint/tendermint/wiki/Byzantine-Consensus-Algorithm#alternative-algorithm
            
              * Censorship Attacks - https://github.com/tendermint/tendermint/wiki/Byzantine-Consensus-Algorithm#censorship-attacks
              
              * Overcoming Forks and Censorship Attacks - https://github.com/tendermint/tendermint/wiki/Byzantine-Consensus-Algorithm#overcoming-forks-and-censorship-attacks

    * Benefits:
      * Speed
        * Tendermint blocks can commit to finality in the order of 1 second
        * TendermintCore can handle transaction volume at the rate of 10,000 transactions per second for 250 byte transactions.
      * Security
        * Tendermint consensus is optimally BFT with accountability since liability may be determined when the blockchain forks
      * Scalability
        * Tendermint may be used for Sharding since it allows running parallel blockchains in parallel without the speed or security of each chain diminishing (unlike with PoW)  
        * Tendermint algorithm can scale to hundreds or thousands of validators (depending on desired block times), and improves over time with advances in bandwidth and CPU capacity.

  * Tendermint Generic Application BlockChain "Interface" (ABCI) is an API between Application Process and Consensus Process. ABCI has a Tendermint Socket Protocol (TSP aka Teaspoon) Implementation:
    * Run in separate Unix processes.
    * De-coupling (abstracting away) the Application State Details of a particular blockchain Application (using a socket protocol) from the Tendermint Core (consensus engine and P2P layers) to avoid a "monolithic" blockchain "stack" design so not limited to just using language of the blockchain stack that compile down to say the Turing-complete bytecode of the Ethereum Virtual Machine (EVM) (i.e. Serpent, Solidity)
    * Allows BFT replication of applications with Transactions processed in any programming language
    * Security guarantees
    * ABCI has 3x Primary Message Types (delivered from Tendermint Core to the ABCI, then ABCI replies with response messages)
      * DeliverTx Message
        * Transactions on the blockchain are delivered with it
        * Validation of Transactions received with the DeliverTx message must be validated by the Application against the current State, Application Protocol, and Transaction's Cryptographic Credentials
        * Valid Transactions update the Application State (i.e binding a value in a KV Store or updating the UTXO DB)
      * CheckTx Message
        * Only for Validating Transactions
        * Validates Transaction using Tendermint Core's Mempool
        * Only Relays Valid Transactions to Peers
        * Invalid Transactions may be caused if a Capabilities Based System is used but they have not renewed their capabilities with each Transaction, or CheckTx in an Application may return an error if a sequence number in a Transaction was not incremented
      * Commit Message
        * Computes the Cryptographic Commitment to the current Application State to be inserted into Next Block Header
        * Inconsistencies and errors in updating State appear as Blockchain Forks 
        * Secure Lightweight Client development is simplified since Merkle-Hash Proofs may be Verified against the Block Hash, which is Signed by a Quorum
    * Applications may have Multiple ABCI Socket Connections (3x created by Tendermint Core), including (see Diagram in https://tendermint.readthedocs.io/en/master/introduction.html#intro-to-abci):
      * Connection 1: Validates Transactions when broadcasting in the Mempool
      * Connection 2: Consensus Engine to run Block Proposals
      * Connection 3: Querying the Application State

    * Application Logic Deterministic
      * Transaction processing on blockchain must be Deterministic so Consensus is reached among Tendermint Core replica Nodes
      * Blockchain Developers should avoid Non-Determinism by using Linters and Static Analysers:
        * Avoid Random Number Generators without Deterministic Seeding
        * Avoid Race Conditions on threads
        * Avoid use of System Clock 
        * Avoid Uninitialised Memory (in Unsafe languages like C or C++)
        * Avoid Floating Point Arithmetic
        * Avoid Random Language Features 

  * Communication between TendermintCore and Tendermint Applications
    * TMSP (Simple Messaging Protocol)

# References <a id="chapter-14"></a>

* Tendermint
  * TODO
    * TODO - TendermintCore Wiki - https://github.com/tendermint/tendermint/wiki/
    * TODO - Application Developers Guide - https://github.com/tendermint/tendermint/wiki/Application-Developers
    * TODO - Byzantine Consensus Algorithm - https://github.com/tendermint/tendermint/wiki/Byzantine-Consensus-Algorithm
    * TODO - Tendermint Documentation - https://tendermint.readthedocs.io/en/master/getting-started.html
    * TODO - Tendermint Documentation Release - https://media.readthedocs.org/pdf/tendermint/master/tendermint.pdf
    * TODO - Tendermine: BFT in the Age of Blockchains - https://allquantor.at/blockchainbib/pdf/buchman2016tendermint.pdf
    * TODO - Cosmos usage of Tendermint
      * https://cosmos.network/about/whitepaper
      * https://cosmos.network/about/faq
    * TODO - Merkle Tree Proof Calculation and Checking - https://github.com/yosriady/merkle_tree

* Erlang 
  * TODO - Erlang Standard Library - http://erlang.org/doc/apps/stdlib/index.html

# Unsorted Notes <a id="chapter-15"></a>

```
cd $GOPATH/src/github.com/tendermint/tendermint
git tag -l
git checkout v0.14.0
```
