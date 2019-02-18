[![Docker Automated build](https://img.shields.io/docker/automated/bsmnetwork/ndasynapse-manifests.svg?style=flat)](https://hub.docker.com/r/bsmnetwork/ndasynapse-manifests)

# NDA manifests to Synapse

This is a Docker container that uses the Python package `ndasynapse` to query the NIMH Data Archive API for data submission manifests related to Brain Somatic Mosaicism Network collections.

## Requirements

1. This Docker container.
2. Username and password to Synapse stored in the AWS Parameter Store.
3. Login credentials to NIMH Data Archive in JSON format for access by the `ndasynapse`, stored in the AWS Parameter Store.

## Usage

To run locally, you need to provide an AWS credentials configuration file to the Docker container:

```
docker run -v /home/kdaily/ndalogs_config.json:/root/ndaconfig.json -v /home/kdaily/.aws/credentials:/root/.aws/credentials bsmn/ndasynapse-manifests:latest
```

To run on an Amazon AWS instance or within the AWS ecosystem, grant IAM permissions to the infrastructure to access the configuration files from the Parameter Store. Then you can run:

```
docker run bsmn/ndasynapse-manifests:latest
```
