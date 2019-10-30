[![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/bsmnetwork/ndasynapse-manifests)](https://hub.docker.com/r/bsmnetwork/ndasynapse-manifests)

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

## Amazon Web Services Infrastructure

This Docker container is provided to run as an AWS Batch job. There are two jobs scripts provided here - [run-live-manifests.sh](run-live-manifests.sh) and [run-original-manifests.sh](run-original-manifests.sh). Each is an AWS Batch array job that queries NDA for the data available through the NDA API GUID query service (the 'live' data) and the NDA API Submission query service (the original submitted manifests). Each outputs CSV files that are [stored in Synapse](https://www.synapse.org/#!Synapse:syn20712253).
