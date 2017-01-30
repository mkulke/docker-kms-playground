#!/bin/bash

set -euo pipefail

while read KEY_VALUE
do
  export "${KEY_VALUE}"
done < <(./envconsul -pristine -consul consul:8500 -once -prefix ${CONSUL_PREFIX} env)

KMS_KEY=${ENC_DATA_KEY#*.}
export PLAINTEXT=$(aws kms decrypt --ciphertext-blob fileb://<(echo $KMS_KEY | base64 --decode) --query Plaintext --output text)
OPENSSL_KEY=$(printenv PLAINTEXT | base64 --decode | hexdump -v -e '/1 "%02x"')
OPENSSL_IV=${ENC_DATA_KEY%.*}

while read KEY
do
  export ${KEY%_ENCRYPTED}="$(printenv $KEY | openssl aes-256-cbc -d -iv $OPENSSL_IV -K $OPENSSL_KEY -base64)"
done < <(compgen -e | grep "_ENCRYPTED$")

unset PLAINTEXT OPENSSL_KEY OPENSSL_IV

env
