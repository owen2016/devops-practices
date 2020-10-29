# CoreDNS

```
user@owen-ubuntu:~/k8s$ kubectl apply -f k8s-demo/controller/coredns.yaml 
serviceaccount/coredns created
clusterrole.rbac.authorization.k8s.io/system:coredns created
clusterrolebinding.rbac.authorization.k8s.io/system:coredns created
configmap/coredns created
unable to recognize "k8s-demo/controller/coredns.yaml": no matches for kind "Deployment" in version "extensions/v1beta1"
Error from server (Invalid): error when creating "k8s-demo/controller/coredns.yaml": Service "kube-dns" is invalid: spec.clusterIP: Invalid value: "10.0.0.2": provided IP is not in the valid range. The range of valid IPs is 10.96.0.0/12
```