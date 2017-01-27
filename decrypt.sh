#!/bin/bash

set -euo pipefail

export PASSPHRASE=$(aws kms decrypt --ciphertext-blob fileb://<(echo ${ENC_DATA_KEY} | base64 --decode) --query Plaintext --output text)

while read LINE
do
  if [[ ${LINE} =~ _ENCRYPTED=.*$ ]]
    then echo "${LINE%_*}=$(echo ${LINE#*=} | base64 --decode | openssl aes-256-cbc -d -pass env:PASSPHRASE)"
    else echo ${LINE}
  fi
done
