#!/bin/bash
# scp_multi_location.sh - A script that allows linux user send files to multiple machines


rpi_list=./rpi_list.txt
rpi_dest=./rpi_destinations.txt
rpi_selected_macs=./rpi_selected_macs.txt
dest_location='/home/pi/workspace/'
IFS=
SSH_USER="pi"
SSHPASS='12345'
CMD_PREFIX="SSHPASS=$SSHPASS sshpass -e"
CMD_SSH="$CMD_PREFIX ssh -p80 -n"
CMD_RSYNC="$CMD_PREFIX rsync -e 'ssh -p80' $@"
SELECTED_MAC=$(sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/|/g' $rpi_selected_macs)

# Check and install sshpass package if not exists
if [ ! dpkg -s sshpass >/dev/null 2>&1 ];
then
    echo "Install sshpass..."
    sudo apt install sshpass -y
fi

# Check and install arp-scan package if not exists
if [ ! dpkg -s arp-scan >/dev/null 2>&1 ];
then
    echo "Install arp-scan tool..."
    sudo apt install arp-scan -y
fi

echo $SCAN_RASPI

if [[ "$SCAN_RASPI" = "True" ]];
then
    echo "Scanning Raspberry Pi..."
    sudo arp-scan --localnet | grep -E "Raspberry Pi Foundation" | \
        grep -E "$SELECTED_MAC" | \
        cut -f1,2  | tee "$rpi_list"
    cat "$rpi_list" | cut -f 1 > "$rpi_dest"
fi

if [[ "$AUTOMATION" = "True" ]];
then
    while read -r ip; do
        echo "######################################"
        echo ">>> Copy files [$ip]..."
        bash -c "$CMD_RSYNC $SSH_USER@$ip:$dest_location"

        echo
        echo ">>> Seting up CamOS..."
        echo ">>> Unarchieving..."
        bash -c "$CMD_SSH $SSH_USER@$ip 'cd $dest_location; \
                tar -xvzf satudora-camos-v0.4.8rc5.tar.gz;'"
        echo ">>> Installing CamOS..."
        bash -c "$CMD_SSH $SSH_USER@$ip \
                'cd $dest_location/satudora-camos-v0.4.8rc5; \
                sudo make NO_RESTORE=y install;'"
        echo
        echo ">>> Done for [$ip]."
        echo
    done < "$rpi_dest"
fi