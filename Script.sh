#!/bin/bash

# Retrieve a list of unused EBS volumes with Volume ID
unused_volumes=$(aws ec2 describe-volumes --filters Name=status,Values=available --query 'Volumes[*].VolumeId' --output text)

# Iterate through each volume and retrieve Name and Size details
echo "Unused EBS volumes:"
for volume_id in $unused_volumes; do
  volume_name=$(aws ec2 describe-volumes --volume-ids "$volume_id" --query 'Volumes[*].Tags[?Key==`Name`].Value' --output text)
  volume_size=$(aws ec2 describe-volumes --volume-ids "$volume_id" --query 'Volumes[*].Size' --output text)
# Replace empty volume names with "null"
  if [ -z "$volume_name" ]; then
    volume_name="null"
  fi
  echo "Volume Name: $volume_name, Volume ID: $volume_id, Size: $volume_size GB"
  echo "------------------------------------------------------------------------"
done

