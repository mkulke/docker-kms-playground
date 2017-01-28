# Consul PoC

## Consul

```
curl -fsSL -X PUT "consul:8500/v1/kv/search/mgns/FOO?token=${CONSUL_TOKEN}" -d "bar"
curl -fsSL -X PUT "consul:8500/v1/kv/search/mgns/ENC_DATA_KEY?token=${CONSUL_TOKEN}" -d "${ENC_DATA_KEY}"
curl -fsSL -X PUT "consul:8500/v1/kv/search/mgns/MY_SECRET_ENCRYPTED?token=${CONSUL_TOKEN}" -d "${MY_SECRET_ENCRYPTED"
```

## Docker

```
docker build -t consul-poc .
docker run \
  -v ~/.aws/credentials:/root/.aws/credentials \
  -e CONSUL_PREFIX=search/mgns consul-poc \
  consul-poc
```
