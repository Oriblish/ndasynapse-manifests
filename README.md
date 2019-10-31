[![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/bsmnetwork/ndasynapse-manifests)](https://hub.docker.com/r/bsmnetwork/ndasynapse-manifests)

# NDA manifests to Synapse

This is a suite of tools that use the Python package `ndasynapse` to query the NIMH Data Archive API for data submission manifests related to Brain Somatic Mosaicism Network collections. This repository contains the definition for a Docker image (in the [`Dockerfile`](Dockerfile)) to perform these tasks.

## Requirements

1. The Docker container (available via `docker pull bsmnetwork/ndasynapse-manifests:latest` or at [DockerHub](https://hub.docker.com/r/bsmnetwork/ndasynapse-manifests).
2. The contents of a [Synapse configuration file](https://docs.synapse.org/articles/client_configuration.html) with a username and password stored in the [AWS Parameter Store](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-parameter-store.html).
3. The contents of a [JSON configuration file](https://github.com/bsmn/ndasynapse#configuration) for the NIMH Data Archive used by the `ndasynapse` package, also stored in the AWS Parameter Store.

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
