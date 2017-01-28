#!/bin/bash

set -euo pipefail

while read KEY_VALUE
do
  export "${KEY_VALUE}"
done < <(./envconsul -pristine -consul consul:8500 -once -prefix ${CONSUL_PREFIX} env)

export PASSPHRASE=$(aws kms decrypt --ciphertext-blob fileb://<(printenv ENC_DATA_KEY | base64 --decode) --query Plaintext --output text)

while read KEY
do
  export ${KEY%_ENCRYPTED}="$(printenv $KEY | base64 --decode | openssl aes-256-cbc -d -pass env:PASSPHRASE)"
done < <(compgen -e | grep "_ENCRYPTED$")

unset PASSPHRASE

env
