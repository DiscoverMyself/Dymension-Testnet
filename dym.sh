#!/bin/bash
clear
echo ""
echo "Wait ..."
sleep 3
clear
       
echo -e "\033[0;35m"
echo "   _____\    _______      ";  
echo "   /      \  |      /\    "; 
echo "  /_______/  |_____/  \   "; 
echo " |   \   /        /   /   "; 
echo "  \   \         \/   /    "; 
echo "   \  /          \__/_    "; 
echo "    \/ ____    /\         "; 
echo "      /  \    /  \        "; 
echo "     /\   \  /   /        "; 
echo "       \   \/   /         "; 
echo "        \___\__/          "; 
echo -e "\e[0m"


# set variables
SOURCE=dymension
BINARY=dymd 
CHAIN=35-C
FOLDER=.dymension
VERSION=v0.2.0-beta
DENOM=udym
COSMOVISOR=cosmovisor
REPO=https://github.com/dymensionxyz/dymension.git
GENESIS=https://raw.githubusercontent.com/obajay/nodes-Guides/main/Dymension/genesis.json
#ADDRBOOK=
PORT=11

# export to bash profile
echo "export SOURCE=${SOURCE}" >> $HOME/.bash_profile
echo "export WALLET=${WALLET}" >> $HOME/.bash_profile
echo "export BINARY=${BINARY}" >> $HOME/.bash_profile
echo "export DENOM=${DENOM}" >> $HOME/.bash_profile
echo "export CHAIN=${CHAIN}" >> $HOME/.bash_profile
echo "export FOLDER=${FOLDER}" >> $HOME/.bash_profile
echo "export VERSION=${VERSION}" >> $HOME/.bash_profile
echo "export COSMOVISOR=${COSMOVISOR}" >> $HOME/.bash_profile
echo "export REPO=${REPO}" >> $HOME/.bash_profile
echo "export GENESIS=${GENESIS}" >> $HOME/.bash_profile
# echo "export ADDRBOOK=${ADDRBOOK}" >> $HOME/.bash_profile
echo "export PORT=${PORT}" >> $HOME/.bash_profile
source $HOME/.bash_profile
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile

sleep 2

# set vars input
if [ ! $NODENAME ]; then
	read -p "Enter node name: " NODENAME
	echo 'export NODENAME='$NODENAME >> $HOME/.bash_profile
fi

if [ ! $WALLET ]; then
	echo "export WALLET=wallet" >> $HOME/.bash_profile
fi

echo "export DYM_CHAIN_ID=35-C" >> $HOME/.bash_profile
echo "export DYM_PORT=54" >> $HOME/.bash_profile
source $HOME/.bash_profile

echo '================================================='
echo -e "Your node name: \e[1m\e[32m$NODENAME\e[0m"
echo -e "Your wallet name: \e[1m\e[32m$WALLET\e[0m"
echo -e "Your chain name: \e[1m\e[32m$CHAIN\e[0m"
echo -e "Your Custom port: \e[1m\e[32m$PORT\e[0m"
echo '================================================='
sleep 2

# update packages
echo -e "\e[1m\e[32m1. Updating packages... \e[0m" && sleep 1
sudo apt update && sudo apt upgrade -y

# Installing dependencies
echo -e "\e[1m\e[32m2. Installing dependencies... \e[0m" && sleep 1
sudo apt install curl build-essential git wget jq make gcc tmux chrony -y

# install go
echo -e "\e[1m\e[32m2. Installing go... \e[0m" && sleep 1
sudo rm -rf /usr/local/go
curl -Ls https://go.dev/dl/go1.19.5.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
eval $(echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/golang.sh)
eval $(echo 'export PATH=$PATH:$HOME/go/bin' | tee -a $HOME/.profile)

# download and build binaries
echo -e "\e[1m\e[32m3. Downloading and building binaries... \e[0m" && sleep 1
cd $HOME
git clone https://github.com/dymensionxyz/dymension.git
cd dymension
git checkout v0.2.0-beta
make install

# install binaries & cosmos sdk
# cd dymension
# git checkout v0.2.0-beta
# make install
# go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.4.0

# create genesis path
# mkdir -p $HOME/.dymension/cosmovisor/genesis/bin
# mv $HOME/go/bin/dymd $HOME/.dymension/cosmovisor/genesis/bin
# rm -rf build

# create app symlinks
#ln -s $HOME/.dymension/cosmovisor/genesis $HOME/.dymension/cosmovisor/current
#sudo ln -s $HOME/.dymension/cosmovisor/current/bin/dymd /usr/local/bin/dymd

# init chain & config app
echo -e "\e[1m\e[32m3. Init chain ...\e[0m" && sleep 1
dymd config chain-id $CHAIN
dymd config keyring-backend test
dymd config node tcp://localhost:${DYM_PORT}657
dymd init $NODENAME --chain-id $CHAIN

# Set seeds & persistent peers
# echo -e "\e[1m\e[32m3. Set seeds & persistent peers... \e[0m" && sleep 1
# sed -i -e "s/^filter_peers *=.*/filter_peers = \"true\"/" $HOME/.dymension/config/config.toml
# external_address=$(wget -qO- eth0.me)
# sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:26656\"/" $HOME/.dymension/config/config.toml
# PEERS="dc237ba44f4f178f6a72b60d9dee2337d424bfce@65.109.85.226:26656,3515bc6054d3e71caf2e04effaad8c95ee4b6dc6@165.232.186.173:26656,e9a375501c0a2eab296a16753667c708ed64649e@95.214.53.46:26656,2d05753b4f5ac3bcd824afd96ea268d9c32ed84d@65.108.132.239:26656"
# SEEDS=""
# sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.dymension/config/config.toml
# sed -i -e "s|^seeds *=.*|seeds = \"$SEEDS\"|" $HOME/.dymension/config/config.toml

# Download genesis file
echo -e "\e[1m\e[32m3. Download genesis file ...\e[0m" && sleep 1
# curl -Ls https://raw.githubusercontent.com/obajay/nodes-Guides/main/Dymension/genesis.json > $HOME/.dymension/config/genesis.json

# Set ports, pruning & snapshots configuration
echo -e "\e[1m\e[32m3. Set ports, pruning & snapshots configuration ...\e[0m" && sleep 1
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${DYM_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${DYM_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${DYM_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${DYM_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${DYM_PORT}660\"%" $HOME/.dymension/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${DYM_PORT}317\"%; s%^address = \":8080\"%address = \":${DYM_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${DYM_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${DYM_PORT}091\"%" $HOME/.dymension/config/app.toml

# Set config pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.dymension/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.dymension/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.dymension/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.dymension/config/app.toml

# Set minimum gas price
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0udym\"/" $HOME/.dymension/config/app.toml

# Enable snapshots
#sed -i -e "s/^snapshot-interval *=.*/snapshot-interval = \"2000\"/" $HOME/.dymension/config/app.toml
#dymd tendermint unsafe-reset-all --home $HOME/.dymension --keep-addr-book
#curl -L https://snapshots.kjnodes.com/okp4-testnet/snapshot_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.dymension


# Create Service
echo -e "\e[1m\e[32m3. Creating service files... \e[0m" && sleep 1
sudo tee /etc/systemd/system/dymd.service > /dev/null << EOF
[Unit]
Description=dymd
After=network-online.target
[Service]
User=$USER
ExecStart=$(which dymd) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.dymension"
Environment="DAEMON_NAME=dymd"
Environment="UNSAFE_SKIP_BACKUP=true"
[Install]
WantedBy=multi-user.target
EOF

# Start Service
sudo systemctl start dymd
sudo systemctl daemon-reload
sudo systemctl enable dymd

echo -e "\e[1m\e[35m================ KELAR CUY, JAN LUPA BUAT WALLET & REQ FAUCET ====================\e[0m"
echo ""
echo -e "To check service status : \e[1m\e[35msystemctl status dymd\e[0m"
echo -e "To check logs status : \e[1m\e[35mjournalctl -fu dymd -o cat\e[0m"
echo -e "To check Blocks status : \e[1m\e[35m$BINARY 2>&1 | jq .SyncInfo\e[0m"
echo ""
sleep 3


