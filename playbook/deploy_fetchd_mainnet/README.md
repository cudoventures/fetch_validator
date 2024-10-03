
# FetchD Ansible Deployment Script
  
## Introduction

The purpose of the playbook is to deploy a Fetch Mainnet Validator using fetchd, it based on the instructions supplied by the Fetch team at: https://fetch.ai/docs/concepts/fetch-network/ledger/validators

## Flow

The playbook is broken into several logical roles to make changes more modular, its easier to add or remove steps this way

### roles:

|Role|Purpose |
|--|--|
| update_upgrade | simple apt update |
| install_go | Install golang from go repos |
| install_software | Install required software from apt repos |
| build_fetch | Pull and build fetchd from the git repos |
| connect_fetch | Connect fetch to the mainnet |
| format_disk | When the client builds the server they add additional storage, this makes use of it |
| move_data | Move the data out of .fetchd onto the new storage |
| pull_snapshot | Pull a snapshot of fetchd down |
| startfetch | Start Fetch as a service (based on a .j2 template file |
  

## Variables

There are variables used within each of the plays, the variables are held in vars/main.yaml

### User Defined Variables
Before running the play 4 variables in the vars/main.yaml file will need to be updated or you will suffer possible data loss.

| Variable Name | Example Data | Notes |
|--|--|--|
|**validatorname:** | YOUR_VALIDATOR_NAME | Enter (without spaces) you preferrerd validator name
|**genesis_file:** | genesis_migrated_5300200.json | This is the Latest JSON file found at https://fetch.ai/docs/references/ledger/active-networks
|**diskpart:** | /dev/sdb | This is the secondary storge disk you have added, use the `fdisk -l` command to identify this
|**diskmount:** | /dev/sdb1 | add the numeric 1 to the end of the drive found in diskpart

Save and exit the file
  
  

## Execution
```
ansible-playbook main.yml
```
## Viewing the systemd service
To view the service status

    sudo systemctl status fetchd

To restart the service

    sudo systemctl restart fetchd

To start the service

    sudo systemctl start fetchd

To stop the service

    sudo systemctl stop fetchd


To view a realtime log steam

    sudo journalctl -fu fetchd


## Funding the Validator

Add a local key

```bash
fetchd keys add <keyname>-key
```
Transfer Funds to this key

```bash
fetchd keys show -a <keyname>-key
```

shows the Fetch Address to send tokens to

```bash
Example: fetch127abc123l2sgtgsmhg33wyarfvddlz
```

Once Funds are available on this wallet run the following command

Remember to use your own values for:
| Value | Details |
|--|--|
| moniker |  The same name you added to the ansible vars |
| from | Enter your fetch wallet key here |

```bash
fetchd tx staking create-validator \\
--amount=1afet   \\
--pubkey=$(fetchd tendermint show-validator)   \\
--moniker="**Add your validator name here"**   \\
--chain-id=fetchhub-4   \\
--commission-rate="0.10"   \\
--commission-max-rate="0.20"   \\
--commission-max-change-rate="0.01"   \\
--min-self-delegation="1"   \\
--gas auto --gas-adjustment 1.3 \\
--gas-prices 0000000000afet  \\
--from=****<keyname>-key**** \\
--node https://rpc-fetchhub.fetch.ai:443

```

This will produce the following output:

```bash
gas estimate: 162177
{"body":{"messages":[{"@type":"/cosmos.staking.v1beta1.MsgCreateValidator",
"description":{"moniker":"cudo-fetch-validator-01","identity":"","website":"",
"security_contact":"","details":""},"commission":{"rate":"0.100000000000000000",
"max_rate":"0.200000000000000000","max_change_rate":"0.010000000000000000"},
"min_self_delegation":"1","delegator_address":"fetch127abc123l2sgtgsmhg33wyarfvddlz",
"validator_address":"fetchvaloper127abc123l2sgtgsmhg33wyarfvddlz",
"pubkey":{"@type":"/cosmos.crypto.ed25519.PubKey",
"key":"2UZ23qReallYAmN0tMhORQhqhzSWofZXVmMI="},
"value":{"denom":"afet","amount":"1"}}],"memo":"","timeout_height":"0",
"extension_options":[],"non_critical_extension_options":[]},"auth_info":{"signer_infos":[],
"fee":{"amount":[],"gas_limit":"162177","payer":"","granter":""}},"signatures":[]}

confirm transaction before signing and broadcasting [y/N]: y
code: 0
codespace: ""
data: ""
events: []
gas_used: "0"
gas_wanted: "0"
height: "0"
info: ""
logs: []
raw_log: '[]'
timestamp: ""
tx: null

```

