#!/bin/bash

set -euo pipefail

KMS_KEY=${ENC_DATA_KEY#*.}
export PLAINTEXT=$(aws kms decrypt --ciphertext-blob fileb://<(echo $KMS_KEY | base64 --decode) --query Plaintext --output text)
OPENSSL_KEY=$(printenv PLAINTEXT | base64 --decode | hexdump -v -e '/1 "%02x"')
OPENSSL_IV=${ENC_DATA_KEY%.*}

while read LINE
do
  if [[ ${LINE} =~ _ENCRYPTED=.*$ ]]
    then echo "${LINE%_*}=$(echo ${LINE#*=} | openssl aes-256-cbc -d -iv $OPENSSL_IV -K $OPENSSL_KEY -base64)"
    else echo ${LINE}
  fi
done
