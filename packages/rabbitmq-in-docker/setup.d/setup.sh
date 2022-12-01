#!/bin/bash

set -x
set -eo pipefail

helm repo add my-repo https://charts.bitnami.com/bitnami
helm install my-release my-repo/postgresql