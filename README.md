<div classname="logo">

<p align="center">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/78480857/209455648-d0686cde-04fb-4e9f-8e18-a863f5e30056.png">
</div>


# Dymension testnet

- [Website](https://www.dymension.xyz/)

- Explorer: -

- [Discord](https://discord.gg/dymension)

- [Medium](https://medium.com/@dymensionXYZ)

- [Twitter](https://twitter.com/dymensionXYZ)

- [Roadmap](https://medium.com/@dymensionXYZ/the-path-forward-revisited-and-updated-1c30b50b1f62)

- [Litepaper](https://docs.dymension.xyz/dymension-litepaper/dymension-litepaper-index)

## Hardware requirements
- OS : Ubuntu Linux 20.04 (LTS) x64

- Read Access Memory : 8 GB (higher better)

- CPU : 2 core (higher better)

- Disk: 500 GB SSD Storage (higher better)

- Bandwidth: 1 Gbps for Download / 100 Mbps for Upload

# Installation
## Automatic Instalation:
```
wget -O dym.sh https://raw.githubusercontent.com/DiscoverMyself/Dymension-Testnet/main/dym.sh && chmod +x dym.sh && ./dym.sh
```

## Manual Instalation
Dymension [Official Docs](https://docs.dymension.xyz/validators/full-node/run-a-node)

# Configurations

## Wallet Configuration
**Add new wallet**
```
dymd keys add $WALLET
```

**Recover wallet**
```
dymd keys add $WALLET --recover
```

**Wallet list**
```
dymd keys list
```

**Check Balance**
```
dymd query bank balances $(dymd keys show wallet -a)
```

**Delete Wallet**
```
dymd keys delete $WALLET
```


## Validator Configuration
**Create Validator**
```
dymd tx staking create-validator \
--amount=9000000udym \
--pubkey=$(dymd tendermint show-validator) \
--moniker=$NODENAME \
--chain-id=$DYM_CHAIN_ID \
--commission-rate=0.1 \
--commission-max-rate=0.2 \
--commission-max-change-rate=0.05 \
--min-self-delegation=1 \
--fees=10000udym \
--from=$WALLET \
-y
```

**Check Validator address**

```
dymd keys show wallet --bech val -a
```

**Edit Validator**

```
dymd tx staking edit-validator \
  --moniker=$NODENAME \
  --identity=<your_keybase_id> \
  --website="<your_website>" \
  --details="<your_validator_description>" \
  --chain-id=$DYM_CHAIN_ID \
  --from=$WALLET
```
 
**Delegate to Validator**
```
dymd tx staking delegate $(dymd tendermint show-validator) 1000000udym --from $WALLET --chain-id $DYM_CHAIN_ID --fees 5000udym
```

**Unjail Validator**
```
dymd tx slashing unjail \
  --broadcast-mode=block \
  --from=$WALLET \
  --chain-id=$DYM_CHAIN_ID \
  --gas=auto --gas-adjustment 1.4
```
  
**Useful Commands**
1. Synchronization info

`
dymd status 2>&1 | jq .SyncInfo
`

2. Validator Info

`
dymd status 2>&1 | jq .ValidatorInfo
`

3. Node Info

`
dymd status 2>&1 | jq .NodeInfo
`

4. Show Node ID

`
dymd tendermint show-node-id
`

5. Delete Node

```
systemctl stop dymd
systemctl disable dymd
rm -rvf .dymd
rm -rvf dym.sh
rm -rvf dymension
```
