
# FetchD Ansible Deployment Script

## TODO
- This currently installs fetchd as root (as per the instructions on the fetch.ai docs) I want it installed as user fetch_user and run out of </opt/fetchd>




## Introduction
This Repo contains the code needed to onboard a client server to the Fetch Mainnet as a validator.
The Deployment is run using GitHub Actions from Jumpbox on CudoCompute.

## Manual Requirements
- Setup automgmt user on remote server 
- Install netbird add to customer/fetchd group
- Update Ansible server /etc/ansible/hosts with netbird IP in customers group
- Run Github Pipeline
- Setup alerts in Grafana for Disk/CPU/RAM etc


## Automation
- Deploys fetchd
- pulls down snapshot
- runs server
- Installs promtail/nodeexporter links to 
- adds UFW with required open ports
- deploys a script on the server for the user to setup local wallet/key 
- Installs a local block height monitoring script which alerts slack if the block height drops



## todo:
- Create a script to send to the user to run as root on the server which will
	- Create user automgmt
	- setup ssh/keys
	- Prompt the user with a code to mail when done
	- install netbird





