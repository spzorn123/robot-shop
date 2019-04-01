#!/bin/sh

if [ "$1" != "create" -a "$1" != "apply" -a "$1" != "delete" -o -z "$2" ]
then
    echo "Usage: k8-manifests.sh COMMAND LABEL"
    echo "  COMMAND: create | apply | delete"
    echo "    LABEL: local | eks | aks | gks | oshift"
    exit 1
fi
export COMMAND=$1

# source variables into manifests and dump to STDOUT
render_manifest() {
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

if [ "$COMMAND" = "apply" -o "$COMMAND" = "create" ]
then
  render_manifest manifests/mongodb-pod.yaml | kubectl $COMMAND -f -
  render_manifest manifests/mongodb-service.yaml | kubectl $COMMAND -f -

  render_manifest manifests/mysql-pod.yaml | kubectl $COMMAND -f -
  render_manifest manifests/mysql-service.yaml | kubectl $COMMAND -f -

  render_manifest manifests/rabbitmq-pod.yaml | kubectl $COMMAND -f -
  render_manifest manifests/rabbitmq-service.yaml | kubectl $COMMAND -f -

  render_manifest manifests/redis-pod.yaml | kubectl $COMMAND -f -
  render_manifest manifests/redis-service.yaml | kubectl $COMMAND -f -

  render_manifest manifests/catalogue-pod.yaml | kubectl $COMMAND -f -
  render_manifest manifests/catalogue-service.yaml | kubectl $COMMAND -f -

  render_manifest manifests/cart-pod.yaml | kubectl $COMMAND -f -
  render_manifest manifests/cart-service.yaml | kubectl $COMMAND -f -

  render_manifest manifests/user-pod.yaml | kubectl $COMMAND -f -
  render_manifest manifests/user-service.yaml | kubectl $COMMAND -f -

  render_manifest manifests/shipping-pod.yaml | kubectl $COMMAND -f -
  render_manifest manifests/shipping-service.yaml | kubectl $COMMAND -f -

  render_manifest manifests/ratings-pod.yaml | kubectl $COMMAND -f -
  render_manifest manifests/ratings-service.yaml | kubectl $COMMAND -f -

  render_manifest manifests/payment-pod.yaml | kubectl $COMMAND -f -
  render_manifest manifests/payment-service.yaml | kubectl $COMMAND -f -

  render_manifest manifests/dispatch-pod.yaml | kubectl $COMMAND -f -
  render_manifest manifests/dispatch-service.yaml | kubectl $COMMAND -f -

  sleep 5

  render_manifest manifests/web-pod.yaml | kubectl $COMMAND -f -
  render_manifest manifests/web-service.yaml | kubectl $COMMAND -f -
else
  kubectl delete pods,services \
    web-$DATACENTER \
    dispatch-$DATACENTER \
    payment-$DATACENTER \
    ratings-$DATACENTER \
    shipping-$DATACENTER \
    user-$DATACENTER \
    cart-$DATACENTER \
    catalogue-$DATACENTER \
    redis-$DATACENTER \
    rabbitmq-$DATACENTER \
    mysql-$DATACENTER \
    mongodb-$DATACENTER
fi
