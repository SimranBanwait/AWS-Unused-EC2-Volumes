#!/bin/bash

region="us-west-2"
output_file="unused_lambda_log_groups.csv"

# Get all log groups
log_groups=$(aws logs describe-log-groups --query 'logGroups[*].logGroupName' --region $region  --output json | tr -d '[],\"' | tr '\\n' ' ')

# Get all Lambda functions
lambda_functions=$(aws lambda list-functions --query 'Functions[*].FunctionName' --region $region --output json | tr -d '[],\"' | tr '\\n' ' ')

echo "Checking for unused Lambda log groups..."

# Prepare CSV file
echo "Log Group Name" > "$output_file"

# Loop through each log group and check if it's associated with a non-existent Lambda function
for log_group in $log_groups; do
  if [[ $log_group == "/aws/lambda/"* ]]; then
    lambda_name=${log_group#/aws/lambda/}

    if ! echo "$lambda_functions" | grep -q "\\b$lambda_name\\b"; then
      echo "Unused log group found: $log_group"
      echo "$log_group" >> "$output_file"
    fi
  fi
done

echo "Check complete. Results are saved in $output_file."

