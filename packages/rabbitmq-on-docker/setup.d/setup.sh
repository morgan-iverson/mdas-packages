#!/bin/bash

set -x
set -eo pipefail

PORT=15672

docker run -d --name rabbitmq-server -p $PORT:$PORT rabbitmq:3-management
