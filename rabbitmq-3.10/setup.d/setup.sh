#!/bin/bash

# Runs BEFORE profile.d (Executions)
set -x
set -eo pipefail

PROJECT_DIR=$(cd "$(dirname $BASH_SOURCE)/.."; pwd) # /opt/packages/postgres-12/

kubectl apply -f $PROJECT_DIR/resources/
kubectl rollout status deployment/postgres


# TEST: k get all