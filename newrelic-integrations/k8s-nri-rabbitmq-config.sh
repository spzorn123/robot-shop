#!/bin/sh

eval "cat <<EOF
integration_name: com.newrelic.rabbitmq

instances:
  - name: $CLUSTER_NAME
    command: "all"
    arguments:
      hostname: rabbitmq-$DATACENTER
EOF
" >> /work-dir/newrelic-infra/integrations.d/
