#!/bin/bash

echo ""
echo "Verifying dynatrace namespace..."
echo ""

ns=`kubectl get namespace dynatrace --no-headers --output=go-template={{.metadata.name}} 2>/dev/null`
if [ -z "${ns}" ]; then
  echo "Namespace dynatrace not found"
  echo ""
  echo "Creating namespace dynatrace:"
  echo ""
  kubectl create namespace dynatrace
else
  echo "Namespace dynatrace exists"
  echo ""
  echo "Using namespace dynatrace"
fi

echo ""
echo "Creating monitoring service account:"

echo ""
kubectl apply -f ./kubernetes-monitoring-service-account.yaml
echo ""

echo "You have to use the following information in the Dynatrace UI:"
echo ""

echo "Kubernetes API URL:"
echo ""
kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}'
echo ""
echo ""
echo "Bearer token:"
echo ""
kubectl get secret $(kubectl get sa dynatrace-monitoring -o jsonpath='{.secrets[0].name}' -n dynatrace) -o jsonpath='{.data.token}' -n dynatrace | base64 --decode
echo ""
echo ""
