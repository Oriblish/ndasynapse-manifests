#!/usr/bin/env bash

synapseusername=`aws secretsmanager --region us-east-1 --output text get-secret-value --secret-id synapse-kdaily-username | cut -f 4`
synapsepassword=`aws secretsmanager --region us-east-1 --output text get-secret-value --secret-id synapse-kdaily-password | cut -f 4`

synapse login -u ${synapseusername} -p ${synapsepassword} --rememberMe

for manifest_type in genomics_subject genomics_sample nichd_btb ; do

    query-nda --config /root/ndaconfig.json get-collection-manifests --collection_id 2963 2967 2968 --manifest_type ${manifest_type} > /tmp/nda-manifests-${manifest_type}.csv && synapse store --parentId syn11452082 /tmp/nda-manifests-${manifest_type}.csv ;

done

