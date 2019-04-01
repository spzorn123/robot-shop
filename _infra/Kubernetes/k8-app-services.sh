#!/bin/sh

if [ "$1" != "create" -a "$1" != "apply" -a "$1" != "delete" -o -z "$2" ]; then
  echo "Usage: k8-app-services.sh COMMAND LABEL"
  echo "  COMMAND: create | apply | delete"
  echo "    LABEL: local | eks | aks | gks | oshift"
  exit 1
fi
export COMMAND=$1

# source variables into manifests and dump to STDOUT
render_yaml() {
eval "cat <<EOF
$(<$1)
EOF
"
}

# list of services
apps=(
  mongodb
  mysql
  rabbitmq
  redis
  catalogue
  cart
  user
  shipping
  ratings
  payment
  dispatch
  web
)

# source the variables from .env
for VAR in $(egrep '^.+=' ../../.env)
do
  export $VAR
done
[ -z "$1" ] || export DATACENTER=$2

# deploy
for app in "${apps[@]}"; do
  render_yaml "manifests/app-services/${app}-pod.yaml" | kubectl $COMMAND -f -
  render_yaml "manifests/app-services/${app}-service.yaml" | kubectl $COMMAND -f -
done
