#!/bin/bash
clear
echo ""
echo "Wait ..."
sleep 3
clear
       
echo -e "\033[0;35m"
echo "    :::     :::::::::  :::::::::      :::     ::::    ::::  :::::::::: "; 
echo "  :+: :+:   :+:    :+: :+:    :+:   :+: :+:   +:+:+: :+:+:+ :+:        ";
echo " +:+   +:+  +:+    +:+ +:+    +:+  +:+   +:+  +:+ +:+:+ +:+ +:+        ";
echo "+#++:++#++: +#++:++#+  +#++:++#:  +#++:++#++: +#+  +:+  +#+ +#++:++#   ";
echo "+#+     +#+ +#+        +#+    +#+ +#+     +#+ +#+       +#+ +#+        ";
echo "#+#     #+# #+#        #+#    #+# #+#     #+# #+#       #+# #+#        ";
echo "###     ### ###        ###    ### ###     ### ###       ### ########## ";
echo -e "\e[0m"
       
                                                               

sleep 2

# set vars
if [ ! $NODENAME ]; then
	read -p "Enter node name: " NODENAME
	echo 'export NODENAME='$NODENAME >> $HOME/.bash_profile
fi

if [ ! $WALLET ]; then
	echo "export WALLET=wallet" >> $HOME/.bash_profile
fi
echo "export DYM_CHAIN_ID=local-testnet" >> $HOME/.bash_profile
source $HOME/.bash_profile

echo '================================================='
echo -e "Your node name: \e[1m\e[32m$NODENAME\e[0m"
echo -e "Your wallet name: \e[1m\e[32m$WALLET\e[0m"
echo -e "Your chain name: \e[1m\e[32m$HUMANS_CHAIN_ID\e[0m"
echo -e "Your port: \e[1m\e[32m$HUMANS_PORT\e[0m"
echo '================================================='
sleep 2

echo -e "\e[1m\e[32m1. Updating packages... \e[0m" && sleep 1
# update
sudo apt update && sudo apt upgrade -y

echo -e "\e[1m\e[32m2. Installing dependencies... \e[0m" && sleep 1
# packages
sudo apt install curl build-essential git wget jq make gcc tmux chrony -y

# install go
if ! [ -x "$(command -v go)" ]; then
  ver="1.19.4"
  cd $HOME
  wget "https://go.dev/dl/go1.19.4.linux-amd64.tar.gz"
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
  rm "go$ver.linux-amd64.tar.gz"
  echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
  source ~/.bash_profile
fi

echo -e "\e[1m\e[32m3. Downloading and building binaries... \e[0m" && sleep 1
# download and build binaries
cd $HOME && rm -rf humans
git clone https://github.com/dymensionxyz/dymension.git --branch v0.1.0-alpha
sudo cp dymd /usr/local/bin/dymd


# init
dymd init "$NODENAME" --chain-id "$CHAIN_ID"
dymd keys add "$WALLET" --keyring-backend test

# download genesis and addrbook
dymd add-genesis-account "$(dymd keys show "$WALLET" -a --keyring-backend test)" 100000000000stake
dymd gentx "$WALLET" 100000000stake --chain-id "$CHAIN_ID" --keyring-backend test
dymd collect-gentxs

# peers



# config pruning


# set peers and seeds


# set minimum gas price and timeout commit

echo -e "\e[1m\e[32m4. Starting service... \e[0m" && sleep 1
# create service
sudo tee /etc/dymd/system/dymd.service > /dev/null <<EOF
[Unit]
Description=dym
After=network-online.target

[Service]
User=$USER
ExecStart=$(which dymd) start --home $HOME/.dymd
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

# start service
sudo systemctl daemon-reload
sudo systemctl enable dymd
sudo systemctl restart dymd

echo '================ KELAR CUY, JAN LUPA BUAT WALLET & REQ FAUCET ===================='
echo -e 'To check logs: \e[1m\e[32mjournalctl -u dymd -f -o cat\e[0m'
echo -e "To check sync status: \e[1m\e[32mdymd status 2>&1 | jq .SyncInfo\e[0m"
