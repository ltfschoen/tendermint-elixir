# Launch multiple bash terminal tab windows by running the command `bash launch.sh`

#!/bin/bash
# File: ~/launch.sh

# Original Code Reference: http://dan.doezema.com/2013/04/programmatically-create-title-tabs-within-the-mac-os-x-terminal-app/
# New-BSD License by Original Author Daniel Doezema http://dan.doezema.com/licenses/new-bsd/

# Modified by Luke Schoen in 2017 to include loading new tabs such as client and server and automatically open webpage in browser.
# Modified by Luke Schoen in 2018 to include launching multiple tabs for Tendermint Testnet Nodes

function new_tab() {
  TAB_NAME=$1
  DELAY=$2
  COMMAND=$3
  osascript \
    -e "tell application \"Terminal\"" \
    -e "tell application \"System Events\" to keystroke \"t\" using {command down}" \
    -e "do script \"$DELAY; printf '\\\e]1;$TAB_NAME\\\a'; $COMMAND\" in front window" \
    -e "end tell" > /dev/null
}

IP=0.0.0.0
AA=tcp://$IP
# "0.0.0.0:46656,0.0.0.0:46666,0.0.0.0:46676,0.0.0.0:46686"
SEEDS="$IP:46656,$IP:46666,$IP:46676,$IP:46686"
TESTNET_ROOT_DIR="/Users/Ls/code/blockchain/tendermint-elixir"
TESTNET_FOLDER="mytestnet"
NODE_0_NAME="mach0"
NODE_1_NAME="mach1"
NODE_2_NAME="mach2"
NODE_3_NAME="mach3"
NODE_LOG_LEVEL="state:info,*:error"
echo "Removing Previous Tendermint Testnet Files: $TESTNET_ROOT_DIR/$TESTNET_FOLDER"
rm -rf "$TESTNET_ROOT_DIR/$TESTNET_FOLDER"
echo "Tendermint Testnet Location: $TESTNET_ROOT_DIR/$TESTNET_FOLDER"
echo "Loading Nodes: $NODE_0_NAME, $NODE_1_NAME, $NODE_2_NAME, $NODE_3_NAME"
echo "Loading Seeds: $SEEDS"
tendermint testnet --home "/Users/Ls/.tendermint" --dir "$TESTNET_ROOT_DIR/$TESTNET_FOLDER" --n 4

new_tab "node_0" \
        "echo 'Loading node_0...'" \
        "bash -c 'echo node_0; tendermint node \
                --home "$TESTNET_ROOT_DIR/$TESTNET_FOLDER/$NODE_0_NAME" \
                --moniker="$NODE_0_NAME" \
                --proxy_app="$AA:46658" \
                --log_level="$NODE_LOG_LEVEL" \
                --rpc.laddr="$AA:46657" \
                --p2p.laddr="$AA:46656" \
                --p2p.seeds=$SEEDS; \
                exec $SHELL'"

new_tab "node_1" \
        "echo 'Loading node_1...'" \
        "bash -c 'echo node_1; tendermint node \
                --home "$TESTNET_ROOT_DIR/$TESTNET_FOLDER/$NODE_1_NAME" \
                --moniker="$NODE_1_NAME" \
                --proxy_app="$AA:46658" \
                --log_level="$NODE_LOG_LEVEL" \
                --rpc.laddr="$AA:46667" \
                --p2p.laddr="$AA:46666" \
                --p2p.seeds=$SEEDS; \
                exec $SHELL'"

new_tab "node_2" \
        "echo 'Loading node_2...'" \
        "bash -c 'echo node_2; tendermint node \
                --home "$TESTNET_ROOT_DIR/$TESTNET_FOLDER/$NODE_2_NAME" \
                --moniker="$NODE_2_NAME" \
                --proxy_app="$AA:46658" \
                --log_level="$NODE_LOG_LEVEL" \
                --rpc.laddr="$AA:46677" \
                --p2p.laddr="$AA:46676" \
                --p2p.seeds=$SEEDS; \
                exec $SHELL'"

new_tab "node_3" \
        "echo 'Loading node_3...'" \
        "bash -c 'echo node_3; tendermint node \
                --home "$TESTNET_ROOT_DIR/$TESTNET_FOLDER/$NODE_3_NAME" \
                --moniker="$NODE_3_NAME" \
                --proxy_app="$AA:46658" \
                --log_level="$NODE_LOG_LEVEL" \
                --rpc.laddr="$AA:46687" \
                --p2p.laddr="$AA:46686" \
                --p2p.seeds=$SEEDS; \
                exec $SHELL'"

