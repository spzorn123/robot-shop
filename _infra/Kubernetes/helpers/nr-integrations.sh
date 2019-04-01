# curl -O http://download.newrelic.com/infrastructure_agent/integrations/kubernetes/k8s-metadata-injection-latest.yaml

# source variables into manifests and dump to STDOUT
render_manifest() {
eval "cat <<EOF
$(<$1)
EOF
"
}

# install kube state metrics 1.5
kubectl apply -f ./manifests-kube-state-metrics

# install NR K8 integration

render_manifest kubectl create -f -
