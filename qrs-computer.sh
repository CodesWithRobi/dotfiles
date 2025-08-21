#!/bin/bash
IP=$(ip neigh | awk 'NR==1{print $1}')

HASH=$(echo | nc $IP 56789 | cat )

if [[ -z $HASH ]]; then

  echo "No data provided for QR"

else

  qrterminal $HASH
  
fi
