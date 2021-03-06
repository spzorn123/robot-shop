#!/bin/sh

eval "cat <<EOF
integration_name: com.newrelic.rabbitmq

instances:
  - name: <cluster name>
    command: <"all", "inventory", or "events">
    arguments:
      hostname: <hostname or IP of RabbitMQ host>
      port: <management UI port>
      username: <management UI username>
      password: <management UI password>
      ca_bundle_dir: <ca bundle directory>
      ca_bundle_file: <ca bundle file>
      node_name_override: <local node name>
      config_path: </path/to/config/file/rabbitmq.conf>
      use_ssl: <bool>
      queues: <json array of queue names to collect>
      queues_regexes: <json array of regexes, matching queue names will be collected>
      exchanges: <json array of exchange names to collect>
      exchanges_regexes: <json array of regexes, matching exchange names will be collected>
      vhosts: <json array of vhost names to collect>
      vhosts_regexes: <json array of regexes, entities assigned to vhosts matching a regex will be collected>
    labels:
      env: production
      role: rabbitmq
EOF
" >> /work-dir/newrelic-infra/integrations.d/
