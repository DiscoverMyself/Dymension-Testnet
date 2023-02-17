#!/bin/bash
clear
echo ""
echo "Wait ..."
sleep 3
clear
       
echo -e "\e[1;32m		                          ";
echo -e "\e[1;32m		    _____\    _______     ";
echo -e "\e[1;32m		   /      \  |      /\    ";
echo -e "\e[1;32m		  /_______/  |_____/  \   ";
echo -e "\e[1;32m		 |   \   /        /   /   ";
echo -e "\e[1;32m		  \   \         \/   /    ";
echo -e "\e[1;32m		   \  /    R3    \__/_    ";
echo -e "\e[1;32m		    \/ ____    /\         ";
echo -e "\e[1;32m		      /  \    /  \        ";
echo -e "\e[1;32m		     /\   \  /   /        ";
echo -e "\e[1;32m		       \   \/   /         ";
echo -e "\e[1;32m		        \___\__/          ";
echo -e "\e[1;32m		                          ";
echo -e "\e[1;32m		     R3 by: Aprame        ";
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
GENESIS=https://raw.githubusercontent.com/DiscoverMyself/Dymension-Testnet/main/genesis.json
#ADDRBOOK=
PORT=26


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

sleep 2

# set vars input
if [ ! $NODENAME ]; then
	read -p "Enter node name: " NODENAME
	echo 'export NODENAME='$NODENAME >> $HOME/.bash_profile
fi

if [ ! $WALLET ]; then
	echo "export WALLET=wallet" >> $HOME/.bash_profile
fi

echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile

echo '========================================================='
echo -e "Your node name: \e[1m\e[32m$NODENAME\e[0m"
echo -e "Your wallet name: \e[1m\e[32m$WALLET\e[0m"
echo -e "Your chain name: \e[1m\e[32m$CHAIN\e[0m"
echo -e "Your Custom port: \e[1m\e[32m$PORT\e[0m"
echo '========================================================='
sleep 2

# update packages
echo -e "\e[1m\e[32m1. Updating packages... \e[0m" && sleep 1
	sudo apt update && sudo apt upgrade -y

# Installing dependencies
echo -e "\e[1m\e[32m2. Installing dependencies... \e[0m" && sleep 1
	sudo apt install curl build-essential git wget jq make gcc tmux chrony lz4 -y

# install go
echo -e "\e[1m\e[32m3. Installing go... \e[0m" && sleep 1
	sudo rm -rf /usr/local/go
	curl -Ls https://go.dev/dl/go1.19.5.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
	eval $(echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/golang.sh)
	eval $(echo 'export PATH=$PATH:$HOME/go/bin' | tee -a $HOME/.profile)

# download and build binaries
echo -e "\e[1m\e[32m4. Downloading and building binaries... \e[0m" && sleep 1
	cd $HOME
	rm -rf $SOURCE
	git clone $REPO --branch $VERSION
	cd $SOURCE
	make install

	# export GOPATH
	export PATH=$PATH:$(go env GOPATH)/bin

# install & build cosmovisor
echo -e "\e[1m\e[32m5. Install & build cosmovisor... \e[0m"
	git clone https://github.com/cosmos/cosmos-sdk
	cd cosmos-sdk
	git checkout v0.46.7
	make cosmovisor
	cp cosmovisor/cosmovisor $GOPATH/bin/cosmovisor
	cd $HOME

	mkdir -p $HOME/$FOLDER/$COSMOVISOR/genesis/bin
	mv $HOME/go/bin/$BINARY $HOME/$FOLDER/$COSMOVISOR/genesis/bin/
	rm -rf build
	cp $GOPATH/bin/$BINARY ~/$FOLDER/$COSMOVISOR/genesis/bin

	# create app symlinks
	ln -s $HOME/$FOLDER/$COSMOVISOR/genesis $HOME/$FOLDER/$COSMOVISOR/current
	sudo ln -s $HOME/$FOLDER/$COSMOVISOR/current/bin/$BINARY /usr/local/bin/$BINARY

	# init chain & config app
	$BINARY config chain-id $CHAIN
	$BINARY config keyring-backend test
	$BINARY config node tcp://localhost:${PORT}657
	$BINARY init $NODENAME --chain-id $CHAIN

# Set seeds & persistent peers
echo -e "\e[1m\e[32m6. Set seeds & persistent peers... \e[0m" && sleep 1
	sed -i -e "s/^filter_peers *=.*/filter_peers = \"true\"/" $HOME/$FOLDER/config/config.toml
	external_address=$(wget -qO- eth0.me)
	sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:26656\"/" $HOME/$FOLDER/config/config.toml
	PEERS="ebc272824924ea1a27ea3183dd0b9ba713494f83@dymension-testnet-peer.autostake.net:27086,9111fd409e5521470b9b33a46009f5e53c646a0d@178.62.81.245:45656,f8a0d7c7db90c53a989e2341746b88433f47f980@209.182.238.30:30657,1bffcd1690806b5796415ff72f02157ce048bcdd@144.76.67.53:2580,c17a4bcba59a0cbb10b91cd2cee0940c610d26ee@95.217.144.107:20556,e6ea3444ac85302c336000ac036f4d86b97b3d3e@38.146.3.199:20556,b473a649e58b49bc62b557e94d35a2c8c0ee9375@95.214.53.46:36656,db0264c412618949ce3a63cb07328d027e433372@146.19.24.101:26646,281190aa44ca82fb47afe60ba1a8902bae469b2a@dymension.peers.stavr.tech:17806,290ec1fc5cc5667d4e072cf336758d744d291ef1@65.109.104.118:60556,d8b1bcfc123e63b24d0ebf86ab674a0fc5cb3b06@51.159.97.212:26656,55f233c7c4bea21a47d266921ca5fce657f3adf7@168.119.240.200:26656,139340424dddf85e54e0a54179d06875013e1e39@65.109.87.88:24656"
	SEEDS="f97a75fb69d3a5fe893dca7c8d238ccc0bd66a8f@dymension-testnet.seed.brocha.in:30584,ebc272824924ea1a27ea3183dd0b9ba713494f83@dymension-testnet-seed.autostake.net:27086,b78dd0e25e28ec0b43412205f7c6780be8775b43@dym.seed.takeshi.team:10356,babc3f3f7804933265ec9c40ad94f4da8e9e0017@testnet-seed.rhinostake.com:20556,c6cdcc7f8e1a33f864956a8201c304741411f219@3.214.163.125:26656"
	sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/$FOLDER/config/config.toml
	sed -i -e "s|^seeds *=.*|seeds = \"$SEEDS\"|" $HOME/$FOLDER/config/config.toml

	# Download genesis file & addrbook
	curl -Ls $GENESIS > $HOME/$FOLDER/config/genesis.json
	#curl -Ls $ADDRBOOK > $HOME/$FOLDER/config/addrbook.json

# Set ports, pruning & snapshots configuration
echo -e "\e[1m\e[32m7. Set ports, pruning & snapshots configuration ...\e[0m" && sleep 1
	sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PORT}660\"%" $HOME/$FOLDER/config/config.toml
	sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${PORT}317\"%; s%^address = \":8080\"%address = \":${PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${PORT}091\"%" $HOME/$FOLDER/config/app.toml

	# Set config pruning
	pruning="custom"
	pruning_keep_recent="100"
	pruning_keep_every="0"
	pruning_interval="10"
	sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/$FOLDER/config/app.toml
	sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/$FOLDER/config/app.toml
	sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/$FOLDER/config/app.toml
	sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/$FOLDER/config/app.toml

	# Set minimum gas price
	sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.15$DENOM\"/" $HOME/$FOLDER/config/app.toml

	# Enable snapshots
	#sed -i -e "s/^snapshot-interval *=.*/snapshot-interval = \"2000\"/" $HOME/.dymension/config/app.toml
	#dymd tendermint unsafe-reset-all --home $HOME/.dymension --keep-addr-book
	#curl -L https://snapshots.kjnodes.com/okp4-testnet/snapshot_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.dymension


# Create Service
echo -e "\e[1m\e[32m8. Creating service files... \e[0m" && sleep 1
sudo tee /etc/systemd/system/$BINARY.service > /dev/null << EOF
[Unit]
Description=$BINARY
After=network-online.target
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/$FOLDER"
Environment="DAEMON_NAME=$BINARY"
Environment="UNSAFE_SKIP_BACKUP=true"
[Install]
WantedBy=multi-user.target
EOF

	# Register And Start Service
	sudo systemctl start $BINARY
	sudo systemctl daemon-reload
	sudo systemctl enable $BINARY


echo -e "\e[1m\e[35m================ KELAR CUY, JAN LUPA BUAT WALLET & REQ FAUCET ====================\e[0m"
echo ""
echo -e "To check service status : \e[1m\e[35msystemctl status $BINARY\e[0m"
echo -e "To check logs status : \e[1m\e[35mjournalctl -fu dymd -o cat\e[0m"
echo -e "To check Blocks status : \e[1m\e[35m$BINARY status 2>&1 | jq .SyncInfo\e[0m"
echo ""
sleep 3


