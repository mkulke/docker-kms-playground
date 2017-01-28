# Docker KMS Playground

Encrypt secrets with a datakey and export the decrypted values to env.

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
MY_SECRET_ENCRYPTED=$(echo "shhhh... secret" | openssl aes-256-cbc -pass env:PLAINTEXT | base64)
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

### Env file

```
cat my.env | ./decrypt.sh
HELLO=WORLD
FOO=BAR
MY_SECRET=shhhh... secret
```

### Docker

```
docker build -t kms-test .
docker run -it \
  -v ~/.aws/credentials:/root/.aws/credentials \
  -e ENC_DATA_KEY=$ENC_DATA_KEY \
  -e MY_SECRET_ENCRYPTED=$MY_SECRET_ENCRYPTED \
  kms-test
```
