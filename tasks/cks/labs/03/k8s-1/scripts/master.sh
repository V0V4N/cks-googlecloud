#!/bin/bash
echo " *** master node  "
curl "https://raw.githubusercontent.com/ViktorUJ/cks/master/tasks/cks/labs/03/k8s-1/scripts/kube-apiserver.yaml" -o "kube-apiserver.yaml"
INTERNAL_IP=`curl -s -H "Metadata-Flavor: Google" http://169.254.169.254/computeMetadata/v1/instance/network-interfaces/0/ip`
sed -i "s/10.2.21.70/$INTERNAL_IP/g" kube-apiserver.yaml
cp kube-apiserver.yaml /etc/kubernetes/manifests/
echo "*** change kube api config "
sleep 30
kubectl get node --kubeconfig=/root/.kube/config
while test $? -gt 0
  do
   sleep 5
   echo "Trying again..."
   kubectl get node   --kubeconfig=/root/.kube/config
  done
date
echo "*** delete  svc kubernetes "
kubectl delete  svc kubernetes   --kubeconfig=/root/.kube/config
