# curl -O http://download.newrelic.com/infrastructure_agent/integrations/kubernetes/k8s-metadata-injection-latest.yaml

# source variables into manifests and dump to STDOUT
render_manifest() {
eval "cat <<EOF
$(<$1)
EOF
"
}

# install kube state metrics (new relic K8 integration dependency)

curl -sLo /tmp/kube-state-metrics-1.4.zip https://codeload.github.com/kubernetes/kube-state-metrics/zip/release-1.4
unzip /tmp/kube-state-metrics-1.4.zip -d /tmp
kubectl apply -f /tmp/kube-state-metrics-release-1.4/kubernetes

# install NR K8 integration

curl -sLo - https://download.newrelic.com/infrastructure_agent/integrations/kubernetes/newrelic-infrastructure-k8s-latest.yaml |
sed -e "s/<YOUR_CLUSTER_NAME>/${CLUSTER_NAME}/g" |
sed -e "s/<YOUR_LICENSE_KEY>/${NEW_RELIC_LICENSE_KEY}/g" |
kubectl create -f -
