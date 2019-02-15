# NDA manifests to Synapse

This is a Docker container that uses the Python package `ndasynapse` to query the NIMH Data Archive API for data submission manifests related to Brain Somatic Mosaicism Network collections.

## Requirements

1. This Docker container.
2. Username and password to Synapse stored in the AWS Secrets Manager.
3. Login credentials to NIMH Data Archive, stored in JSON format for access by the `ndasynapse`.

## Usage

To run locally, you need to provide an AWS credentials configuration file to the Docker container:

```
docker run -v /home/kdaily/ndalogs_config.json:/root/ndaconfig.json -v /home/kdaily/.aws/credentials:/root/.aws/credentials bsmn/ndasynapse:latest
```

To run on an Amazon AWS instance or within the AWS ecosystem, grant IAM permissions to the infrastructure to access the secrets from the Secrets Manager. Then you can run:

```
docker run -v /home/kdaily/ndalogs_config.json:/root/ndaconfig.json bsmn/ndasynapse:latest
```
