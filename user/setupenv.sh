#!/bin/bash
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

update_server(){
#Update the server with the latest software
apt update
apy upgrade -y
}

intro(){
echo -e "
 _    _ _______        _____ ______  _______ _______  _____   ______     
  \  /  |_____| |        |   |     \ |_____|    |    |     | |_____/     
   \/   |     | |_____ __|__ |_____/ |     |    |    |_____| |    \_     
 _______ _______ _______ _     _  _____                                  
 |______ |______    |    |     | |_____]                                 
 ______| |______    |    |_____| |                                 
"
}


install_software(){
#Install ansible (and any other required software to bootstrap the server
echo -e "${GREEN}Updating server:${NC}\n${YELLOW}Please Wait${NC}"
apt install ansible -y
echo -e "${GREEN}Updating server:${NC}\n${YELLOW}Complete${NC}"
}

install_netbird(){
#Install the netbird VPN client for non public IP Access
echo -e "${GREEN}Installing VPN Client:${NC}\n${YELLOW}Please Wait${NC}"
curl -fsSL https://pkgs.netbird.io/install.sh | sh
netbird up --setup-key 97F71234-E1BA-4250-8001-73A765CDDAEC
echo -e "${GREEN}Installing VPN Client:${NC}\n${YELLOW}Complete${NC}"
}

setup_users(){
echo -e "${GREEN}Setting up users and SSH using Ansible:${NC}\n${YELLOW}Please Wait${NC}"
echo -e "${Yellow}\nThis should take approx 2 minutes${NC}"
# ansible script to setup users and ssh access from Cudo
#ansible-playbook playbook/main.yml --vault-password-file ~/.ansible_vault_password
ansible-playbook playbook/main.yaml
echo -e "${GREEN}Setting up users and SSH using Ansible:${NC}\n${YELLOW}Complete${NC}"
}

copypaste(){
echo -e "${GREEN}Setup Complete${NC}"
echo -e "${YELLOW}Please Send the following information to Cudos${NC}"
echo -e "Hostname: $(hostname -f)"
echo -e "Public IP: $(ip a show eth0 | grep 'inet ' | awk '{print $2}' | cut -d'/' -f1)"
echo -e "VPN IP: $(ip a show wt0 | grep 'inet ' | awk '{print $2}' | cut -d'/' -f1)"
echo -e "Automgmt User: $(id automgmt)"
echo -e "fetch_user User: $(id fetch_user)"
echo -e "Automgmt SSH Key: $(cat /home/automgmt/.ssh/authorized_keys)"
echo -e "Available disks: $(fdisk -l)"
}

sethostname(){
read -r -p "Do you want to change the hostname of the server from $HOSTNAME (y/N)? " response
response=${response,,}  # Convert to lowercase

if [[ "$response" == "y" || "$response" == "yes" ]]; then
    while true; do
        # Prompt for the new hostname
        read -r -p "What hostname would you like? " new_hostname

        # Confirm the new hostname
        read -r -p "Is this correct: $new_hostname (y/N)? " confirm
        confirm=${confirm,,}  # Convert to lowercase

        if [[ "$confirm" == "y" || "$confirm" == "yes" ]]; then
            # Set the new hostname
            sudo hostnamectl set-hostname "$new_hostname"
            echo "Hostname is $(hostname)"
        else
            echo "Let's try again."
        fi
    done
else
    # Display current hostname
    echo "Hostname is $HOSTNAME"
fi

}



#Run script
#Execute each of these functions 
intro
update_server
install_software
install_netbird
setup_users
copypaste


echo "Done"


