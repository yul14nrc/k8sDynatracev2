# Kubernetes with Dynatrace
Scripts to integrate dynatrace operator with K8s Cluster, and also kubernetes cluster with dynatrace:

[1-Credentials](https://github.com/yul14nrc/k8sDynatrace/tree/master/1-Credentials): Used to define the environment, API and Paas token from dynatrace
[2-Dyna-K8s-Operator](https://github.com/yul14nrc/k8sDynatrace/tree/master/2-Dyna-K8s-Operator): Used to install or unistall the dynatrace operator for kubernetes cluster.
[3-Conect-K8SCluster-Dynatrace](https://github.com/yul14nrc/k8sDynatrace/tree/master/3-Conect-K8SCluster-Dynatrace): Used to create the service account required to connect the kubernetes cluster with dynatrace

Important Note:

To dynatrace can obtain metrics from Kubernetes API, you must add the Kubernetes cluster certificate to Dynatrace Active Gate.

Configuring custom trust store file in Dynatrace Active Gate:

To configure ActiveGate to use a custom trust store file Copy the trusted.jks file to the SSL directory. Add the following entries to the config/custom.properties file:

[collector]
trustedstore = trusted.jks
trustedstore-password = trusted
trustedstore-type = JKS
