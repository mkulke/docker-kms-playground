# Consul PoC

## Docker

```
docker build -t consul-poc .
docker run \
  -v ~/.aws/credentials:/root/.aws/credentials \
  -e CONSUL_PREFIX=search/mgns consul-poc \
  consul-poc
```
