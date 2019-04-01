#!/bin/sh

eval "cat <<EOF
integration_name: com.newrelic.mongodb

instances:
  - name: all
    # Available commands are "all", "metrics", and "inventory"
    command: all
    arguments:
      # The mongos to connect to
      host: my-mongos.company.localnet
      # The port the mongos is running on
      port: 27017
      # The username of the user created to monitor the cluster.
      # This user should exist on the cluster as a whole as well
      # as on each of the individual mongods.
      username: monitor
      # The password for the monitoring user
      password: password
      # The database on which the monitoring user is stored
      auth_source: admin
      # Connect using SSL
      ssl: true
      # Skip verification of the certificate sent by the host.
      # This can make the connection susceptible to man-in-the-middle attacks,
      # and should only be used for testing
      ssl_insecure_skip_verify: true
      # Path to the CA certs file
      ssl_ca_certs: /sample/path/to/ca_certs
      # A JSON map of database names to an array of collection names. If empty,
      # defaults to all databases and collections. If the list of collections is null,
      # collects all collections for the database.
      filters: '{"db1":null,"db2":["collection1","collection2"],"db3":[]}'
    labels:
      env: production
      label: mongo-cluster-1
EOF
" >> /work-dir/newrelic-infra/integrations.d/
