#!/bin/bash

exec > >(tee -i ./uninstalldynaoperator.log)
exec 2>&1

kubectl delete -n dynatrace oneagent --all

kubectl delete secret oneagent -n dynatrace

dynaoperator=`kubectl get deployment dynatrace-oneagent-operator -n dynatrace -o=jsonpath='{$.spec.template.spec.containers[:1].image}'`
version=$(echo "$dynaoperator" | cut -d':' -f 2)

kubectl delete -f https://raw.githubusercontent.com/Dynatrace/dynatrace-oneagent-operator/$version/deploy/kubernetes.yaml
