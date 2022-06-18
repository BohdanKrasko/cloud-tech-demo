kubectl delete -f prometheus.yaml -n prometheus
kubectl delete -f grafana.yaml -n grafana
helm delete prometheus prometheus-community/prometheus --namespace prometheus
kubectl delete namespace grafana
kubectl delete namespace prometheus
kubectl delete -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml