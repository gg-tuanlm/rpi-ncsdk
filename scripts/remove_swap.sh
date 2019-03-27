#!/bin/bash
SWAP=/media/${USER}/rootfs/var/swap

if [ -f ${SWAP} ]
then
    sudo rm ${SWAP}
    echo "Swap removed!";
else
    echo "Swap not found, nothing else to do."
fi
