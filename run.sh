#!/usr/bin/env bash

aws ssm get-parameters --names synapseconfig-kdaily --with-decryption --region us-east-1 --output text --query "Parameters[*].{Value:Value}" > /root/.synapseConfig
aws ssm get-parameters --names nda-config --with-decryption --region us-east-1 --output text --query "Parameters[*].{Value:Value}" > /root/ndaconfig.json

for manifest_type in genomics_subject genomics_sample nichd_btb ; do

    query-nda --config /root/ndaconfig.json get-collection-manifests --collection_id 2458 2960 2961 2962 2963 2964 2965 2966 2967 2968 --manifest_type ${manifest_type} > /tmp/nda-manifests-${manifest_type}-ORIGINAL.csv && synapse store --parentId syn11452082 /tmp/nda-manifests-${manifest_type}-ORIGINAL.csv ;

done

for manifest_type in genomics_subject02 genomics_sample03 nichd_btb02 ; do
    manifest_guid_data.py --config /root/ndaconfig.json --collection_id 2458 2960 2961 2962 2963 2964 2965 2966 2967 2968 --manifest_type ${manifest_type} >| > /tmp/nda-manifests-${manifest_type}-LIVE.csv && synapse store --parentId syn11452082 /tmp/nda-manifests-${manifest_type}-LIVE.csv;
done
