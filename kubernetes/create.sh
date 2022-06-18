kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
kubectl create namespace prometheus
kubectl create namespace grafana
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm upgrade -i prometheus prometheus-community/prometheus \
  --namespace prometheus \
  --set alertmanager.persistentVolume.storageClass="gp2",server.persistentVolume.storageClass="gp2"
kubectl apply -f grafana.yaml -n grafana
kubectl apply -f prometheus.yaml -n prometheus

# Dasboad ID 6663
# Grafana URL: grafana.cloud-tech-demo.pp.ua
# Prometheus URL: prometheus.cloud-tech-demo.pp.ua