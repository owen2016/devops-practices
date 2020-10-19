# Kube-Prometheus


- https://github.com/loveqx/k8s-study


## Access the dashboards

Prometheus

`$ kubectl --namespace monitoring port-forward svc/prometheus-k8s 9090`
Then access via http://localhost:9090

Grafana

` $ kubectl --namespace monitoring port-forward svc/grafana 3000`
Then access via http://localhost:3000 and use the default grafana user:password of admin:admin.

Alert Manager

`$ kubectl --namespace monitoring port-forward svc/alertmanager-main 9093`
Then access via http://localhost:9093


https://github.com/loveqx/k8s-study