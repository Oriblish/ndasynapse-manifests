#!/usr/bin/env bash

aws ssm get-parameters --names synapseconfig-kdaily --with-decryption --region us-east-1 --output text --query "Parameters[*].{Value:Value}" > /root/.synapseConfig
aws ssm get-parameters --names nda-config --with-decryption --region us-east-1 --output text --query "Parameters[*].{Value:Value}" > /root/ndaconfig.json

for manifest_type in genomics_subject genomics_sample nichd_btb ; do

    query-nda --config /root/ndaconfig.json get-collection-manifests --collection_id 2960 2961 2962 2963 2964 2965 2966 2967 2968 --manifest_type ${manifest_type} > /tmp/nda-manifests-${manifest_type}.csv && synapse store --parentId syn11452082 /tmp/nda-manifests-${manifest_type}.csv ;

done

