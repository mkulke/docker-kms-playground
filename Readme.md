# AWS KMS Playground

Encrypt secrets with a datakey and decrypt them in an env map.

## Create AES Datakey

```
export KEY_ARN= # Root key arn
aws kms generate-data-key --key-id ${KEY_ARN} --key-spec AES_256
```

The call should return `Plaintext` and `CiphertextBlob` strings. Export both (the Plaintext string should not end up in history).

```
read -s PLAINTEXT
export PLAINTEXT
export ENC_DATA_KEY="AbC...z="
```

## Encrypt Secret with Plaintext

```
MY_SECRET_ENCRYPTED=$(echo "shhhh" | openssl aes-256-cbc -pass env:PLAINTEXT | base64)
```

## Env File

```
cat <<EOF > my.env
HELLO=WORLD
FOO=BAR
MY_SECRET_ENCRYPTED=$MY_SECRET_ENCRYPTED
EOF
```

## Decrypt

```
cat my.env | ./decrypt.sh
HELLO=WORLD
FOO=BAR
MY_SECRET=shhhh
```
