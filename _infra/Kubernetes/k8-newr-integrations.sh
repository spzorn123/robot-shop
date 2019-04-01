#!/bin/sh

if [ "$1" != "create" -a "$1" != "apply" -a "$1" != "delete" -o -z "$2" ]; then
  echo "Usage: k8-newr-integrations.sh COMMAND LABEL"
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

# source the variables from .env
for VAR in $(egrep '^.+=' ../../.env)
do
  export $VAR
done
[ -z "$1" ] || export DATACENTER=$2

# deploy
for yaml in manifests/newr-integrations/*; do
  render_yaml "${yaml}" | kubectl $COMMAND -f -
done
