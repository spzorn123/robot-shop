#!/bin/sh

eval "cat <<EOF
integration_name: com.newrelic.apache

instances:
    - name: apache-server-metrics
      command: metrics
      arguments:
          status_url: http://127.0.0.1/server-status?auto

          # New users should leave this property as `true`, to identify the
          # monitored entities as `remote`. Setting this property to `false` (the
          # default value) is deprecated and will be removed soon, disallowing
          # entities that are identified as `local`.
          # Please check the documentation to get more information about local
          # versus remote entities:
          # https://github.com/newrelic/infra-integrations-sdk/blob/master/docs/entity-definition.md
          remote_monitoring: true
      labels:
          env: production
          role: load_balancer
    - name: apache-server-inventory
      command: inventory
      arguments:

          # New users should leave this property as `true`, to identify the
          # monitored entities as `remote`. Setting this property to `false` (the
          # default value) is deprecated and will be removed soon, disallowing
          # entities that are identified as `local`.
          # Please check the documentation to get more information about local
          # versus remote entities:
          # https://github.com/newrelic/infra-integrations-sdk/blob/master/docs/entity-definition.md
          remote_monitoring: true
      labels:
          env: production
          role: load_balancer
EOF
" >> /work-dir/newrelic-infra/integrations.d/
