##########  yaml file to download the load balancer controllers for the k8s cluster for alibaba cloud #####
https://github.com/alibaba/alibaba-load-balancer-controller/blob/v1.1.2/deploy/v1/load-balancer-controller.yaml

### k8s useful commands 
kubectl get pods ,  and also, kubectl get pods -o wide
kubectl run nginx --image=nginx
kubectl describe pod <pod-name> ,     
kubectl run redis --image-redis --dey-run=client -o yaml

services:
kubectl get service
kubectl get service kubernetes --show-labels
kubectl get endpoints kubernetes
kubectl get deployments / <deployment-name>
kubectl describe deployments simple-webapp-deployment

Deployments
kubectl describe deployments.apps frontend
kubectl set image deployment/frontend simple-webapp=kodekloud/webapp-color:v2
kubectl -n kube-system get all | grep load-balancer
k logs pod/load-balancer-controller-568b9c8fd5-mmnm6 -n kube-system

export KUBECONFIG=~/.kube/serverless
