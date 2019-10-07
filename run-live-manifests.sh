#!/usr/bin/env bash

LINE=$((AWS_BATCH_JOB_ARRAY_INDEX + 1))
manifest_type=$(sed -n ${LINE}p /manifest_types.txt)

# Query NDA using the GUID query service for all BSMN collections

aws ssm get-parameters --names synapseconfig-kdaily --with-decryption --region us-east-1 --output text --query "Parameters[*].{Value:Value}" > /root/.synapseConfig
aws ssm get-parameters --names nda-config --with-decryption --region us-east-1 --output text --query "Parameters[*].{Value:Value}" > /root/ndaconfig.json

echo "Running ndasynapse" $(query-nda --version) > /dev/stderr

manifest_guid_data.py --config /root/ndaconfig.json --collection_id 2458 2960 2961 2962 2963 2964 2965 2966 2967 2968 --manifest_type ${manifest_type} > /tmp/nda-manifests-${manifest_type}-LIVE.csv && synapse store --parentId syn20858271 /tmp/nda-manifests-${manifest_type}-LIVE.csv;
