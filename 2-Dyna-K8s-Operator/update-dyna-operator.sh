#!/bin/bash

exec > >(tee -i ./updatedynaoperator.log)
exec 2>&1

PREVIOUS_RELEASE=`kubectl get deployment dynatrace-oneagent-operator -n dynatrace -o=jsonpath='{$.spec.template.spec.containers[:1].image}'`
PREVIOUS_VERSION=$(echo "$PREVIOUS_RELEASE" | cut -d':' -f 2)

LATEST_VERSION=$(curl -s https://api.github.com/repos/dynatrace/dynatrace-oneagent-operator/releases/latest | grep tag_name | cut -d '"' -f 4)

if [ "$PREVIOUS_VERSION" = "$LATEST_VERSION" ]; then
        echo "The dynatrace-oneagent-operator is updated."
else
        echo "Previous dynatrace-oneagent-operator version: "$PREVIOUS_VERSION
        echo "Lastest dynatrace-oneagent-operator version: "$LATEST_VERSION
        echo ""
        echo "Updating..."

        kubectl delete -n dynatrace oneagent --all

        kubectl delete -f https://raw.githubusercontent.com/Dynatrace/dynatrace-oneagent-operator/$PREVIOUS_VERSION/deploy/kubernetes.yaml

        export API_TOKEN=$(cat ../1-Credentials/creds.json | jq -r '.dynatraceApiToken')
        export PAAS_TOKEN=$(cat ../1-Credentials/creds.json | jq -r '.dynatracePaaSToken')
        export TENANTID=$(cat ../1-Credentials/creds.json | jq -r '.dynatraceTenantID')
        export ENVIRONMENTID=$(cat ../1-Credentials/creds.json | jq -r '.dynatraceEnvironmentID')
        
        kubectl create -f https://raw.githubusercontent.com/Dynatrace/dynatrace-oneagent-operator/$LATEST_VERSION/deploy/kubernetes.yaml

        if [[ -f "cr.yaml" ]]; then
                rm -f cr.yaml
                echo "Removed cr.yaml"
        fi

        curl -o cr.yaml https://raw.githubusercontent.com/Dynatrace/dynatrace-oneagent-operator/$LATEST_VERSION/deploy/cr.yaml

        case $ENVIRONMENTID in
                '')
                echo "SaaS Deplyoment"
                sed -i 's/apiUrl: https:\/\/ENVIRONMENTID.live.dynatrace.com\/api/apiUrl: https:\/\/'$TENANTID'.live.dynatrace.com\/api/' cr.yaml
                ;;
                *)
                echo "Managed Deployment"
                sed -i 's/apiUrl: https:\/\/ENVIRONMENTID.live.dynatrace.com\/api/apiUrl: https:\/\/'$TENANTID'.dynatrace-managed.com\/e\/'$ENVIRONMENTID'\/api/' cr.yaml
                ;;
                ?)
                usage
                ;;
        esac

        kubectl create -f cr.yaml

fi
