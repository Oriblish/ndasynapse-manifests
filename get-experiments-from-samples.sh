#!/usr/bin/env bash

# Get credentials for Synapse and NDA
aws ssm get-parameters --names synapseconfig-kdaily --with-decryption --region us-east-1 --output text --query "Parameters[*].{Value:Value}" > /root/.synapseConfig
aws ssm get-parameters --names nda-config --with-decryption --region us-east-1 --output text --query "Parameters[*].{Value:Value}" > /root/ndaconfig.json

# ID of the genomics_sample file to get experiment IDs from
GENOMICS_SAMPLE_FILE_ID='syn20822548'

# Synapse Folder to store output file in
OUTPUT_FOLDER_ID='syn20858271'

synapse cat ${GENOMICS_SAMPLE_FILE_ID} | cut -f 2 -d, | tail -n +2 | sed 's/"//g' | sort | uniq | xargs -P20 -I{} -n 1 sh -c 'query-nda --config /root/ndaconfig.json get-experiments --experiment_id "$1" >| "/tmp/nda-experiment-$1.csv"' -- {}

/concatenate-csvs.py /tmp/nda-experiment-*.csv > /tmp/nda-experiments-LIVE.csv
synapse store --noForceVersion --parentId ${OUTPUT_FOLDER_ID} /tmp/nda-experiments-LIVE.csv
