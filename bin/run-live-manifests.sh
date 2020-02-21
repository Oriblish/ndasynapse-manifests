#!/usr/bin/env bash

set -o errexit

LINE=$((AWS_BATCH_JOB_ARRAY_INDEX + 1))
manifest_type=$(sed -n ${LINE}p /config/manifest_types_versioned.txt)

# Query NDA using the GUID query service for all BSMN collections

aws ssm get-parameters --names /bsmn-ndasynapse-manifests/synapseConfig --with-decryption --region us-east-1 --output text --query "Parameters[*].{Value:Value}" > /root/.synapseConfig
aws ssm get-parameters --names /bsmn-ndasynapse-manifests/ndaConfig --with-decryption --region us-east-1 --output text --query "Parameters[*].{Value:Value}" > /root/ndaconfig.json

echo "Running ndasynapse" $(query-nda --version) > /dev/stderr

cat /config/collection_ids.txt | xargs -P8 -I{} -n 1 sh -c 'query-nda --config /root/ndaconfig.json get-guid-collection-manifests --manifest_type ${1} --collection_id ${2} > /tmp/nda-manifest-${1}-${2}-LIVE.csv' -- ${manifest_type} {}

# Due to a Pandas bug (https://github.com/pandas-dev/pandas/issues/15891)
# Cannot output an empty data frame to csv, so find files of size 1 and delete them.
find /tmp/ -maxdepth 1 -name "nda-manifest-${manifest_type}*-LIVE.csv" -size 1 -delete

# Concatenate all files together and sort the columns.
# The columns are sorted alphabetically so that if the contents haven't changed
# then a new version is not pushed to Synapse.
concatenate-csvs.py /tmp/nda-manifest-${manifest_type}-*-LIVE.csv | sort-columns.py > /tmp/nda-manifests-${manifest_type}-LIVE-unsorted.csv

# Need to sort rows too
head -n 1 /tmp/nda-manifests-${manifest_type}-LIVE-unsorted.csv > /tmp/nda-manifests-${manifest_type}-LIVE.csv
tail -n +2 /tmp/nda-manifests-${manifest_type}-LIVE-unsorted.csv | sort >> /tmp/nda-manifests-${manifest_type}-LIVE.csv

# Store in Synapse
synapse store --noForceVersion --parentId syn20858271 /tmp/nda-manifests-${manifest_type}-LIVE.csv
