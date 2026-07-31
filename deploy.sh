#!/bin/bash

set -e

if [ $# -lt 2 ]; then
  echo "Usage: $0 <environment> <command>"
  echo "Example: $0 dev plan"
  exit 1
fi

ENVIRONMENT=$1
COMMAND=$2

cd "$(dirname "$0")/environments/$ENVIRONMENT"

export AWS_PROFILE=default

terragrunt $COMMAND
