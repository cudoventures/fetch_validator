---
- name: Configure Fetch chain ID
  become: yes
  command: sudo /root/go/bin/fetchd config chain-id {{ fetchchainid }}



- name: Configure Fetch node
  become: yes
  command: sudo /root/go/bin/fetchd config node https://rpc-fetchhub.fetch.ai:443

- name: Initialize Fetch with chain ID
  become: yes
  command: sudo /root/go/bin/fetchd init {{ validatorname }} --chain-id {{ fetchchainid }}

- name: Download Fetch genesis file
  become: yes
  get_url:
    url: https://raw.githubusercontent.com/fetchai/genesis-fetchhub/{{ fetchchainid }}/{{ fetchchainid }}/data/{{ genesis_file }}
    dest: /opt/fetchd/.fetchd/config/genesis.json

- name: Set ownership of /opt/fetchd/.fetchd/config/genesis.json to fetch_user
  become: yes
  ansible.builtin.file:
    path: /opt/fetchd/.fetchd/config/genesis.json
    owner: fetch_user
    group: fetch_user
    state: file  # Ensures the target is a file
