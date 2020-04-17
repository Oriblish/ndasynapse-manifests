# NDA manifests to Synapse

[![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/bsmnetwork/ndasynapse-manifests)](https://hub.docker.com/r/bsmnetwork/ndasynapse-manifests)

This is a suite of tools that use the Python package `ndasynapse` to query the NIMH Data Archive API for data submission manifests related to Brain Somatic Mosaicism Network collections. This repository contains the definition for a Docker image (in the [`Dockerfile`](Dockerfile)) to perform these tasks. The tools get data from a limited set of possible manifest types defined at NDA. These are set in the [`manifest_types_versioned.txt`](config/manifest_types_versioned.txt) (versioned manifest type, like `genomics_subject02`) and [`manifest_types_unversioned.txt`](config/manifest_types_unversioned.txt) (unversioned manifest type, like `genomics_subject`) files.

## Requirements

1. The Docker container (available via `docker pull bsmnetwork/ndasynapse-manifests:latest` or at [DockerHub](https://hub.docker.com/r/bsmnetwork/ndasynapse-manifests).
2. The contents of a [Synapse configuration file](https://docs.synapse.org/articles/client_configuration.html) with a username and password stored in the [AWS Parameter Store](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-parameter-store.html) at `/bsmn-ndasynapse-manifests/synapseConfig`.
3. The contents of a [JSON configuration file](https://github.com/bsmn/ndasynapse#configuration) for the NIMH Data Archive used by the `ndasynapse` package, also stored in the AWS Parameter Store at `/bsmn-ndasynapse-manifests/ndaConfig`.

## Usage

To run locally, you need to provide an AWS credentials configuration file to the Docker container:

```terminal
docker run -v /home/kdaily/.aws/credentials:/root/.aws/credentials bsmn/ndasynapse-manifests:latest
```

To run on an Amazon AWS instance or within the AWS ecosystem, grant IAM permissions to the infrastructure to access the configuration files from the Parameter Store. Then you can run:

```terminal
docker run bsmn/ndasynapse-manifests:latest
```

## Amazon Web Services Infrastructure

This Docker container is provided to run as an AWS Batch job. Each is an AWS Batch array job that queries NDA for the data available through the NDA API GUID query service (the 'live' data) and the NDA API Submission query service (the original submitted manifests). Each outputs CSV files that are [stored in Synapse](https://www.synapse.org/#!Synapse:syn20712253). There are two jobs scripts provided here:

1. [run-live-manifests.sh](bin/run-live-manifests.sh) gets the live data. It uses the [`manifest_types.txt`](config/manifest_types.txt) file to create the array jobs - one for each manifest type.
1. [run-original-manifests.sh](bin/run-original-manifests.sh) gets the historical (originally submitted) data. It uses the [`manifest_types.txt`](config/manifest_types.txt) file and strips the version number (last two digits) to create the array jobs - one for each manifest type.

These tasks require access to the AWS Parameter store, in which the contents of the `ndaconfig.json` and Synapse configuration file are required to be stored. They must be stored in parameters named `/bsmn-ndasynapse-manifests/synapseConfig` and `/bsmn-ndasynapse-manifests/ndaConfig`.

There are also two example AWS Batch job definition templates ([ndamanifests-live-array-job.json](ndamanifests-live-array-job.json) and [ndamanifests-original-array-job.json](ndamanifests-original-array-job.json) that can be used to submit directly to a configured job queue using the AWS command line interface:

```
aws batch submit-job --cli-input-json file:///path/to/ndasynapse-manifests/ndamanifests-original-array-job.json
```

TODO: Document the AWS infrastructure required to run this on an automated basis (this is being developed into a CloudFormation template at [Sage-Bionetworks/bsmn-ndasynapse-manifests-aws-infra](https://github.com/Sage-Bionetworks/bsmn-ndasynapse-manifests-aws-infra):

1. Batch compute environment
1. Batch job queue
1. Batch job definitions
1. Cloudwatch Event Rule (scheduled)
1. Policies to access secret config files in parameter store

## Development

The Dockerfile uses a `pip` requirements file (`requirements.txt`) for dependencies. When updating the package used to interface with NDA, `ndasynapse`, be sure to change the version number required in this file.
