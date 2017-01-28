#!/bin/bash

set -euo pipefail

export PASSPHRASE=$(aws kms decrypt --ciphertext-blob fileb://<(printenv ENC_DATA_KEY | base64 --decode) --query Plaintext --output text)

while read KEY
do
  export ${KEY%_ENCRYPTED}="$(printenv $KEY | base64 --decode | openssl aes-256-cbc -d -pass env:PASSPHRASE)"
done < <(compgen -e | grep "_ENCRYPTED$")

unset PASSPHRASE

exec watch -n5 printenv MY_SECRET
