# k8sDynatrace
Scripts to integrate dynatrace operator with K8s Cluster, and also kubernetes cluster with dynatrace:

[1-Credentials](https://github.com/yul14nrc/k8sDynatrace/tree/master/1-Credentials) Used to define the environment, API and Paas token from dynatrace

To dynatrace can obtain metrics from Kubernetes API, you must add the Kubernetes cluster certificate to Dynatrace Active Gate.

Configuring custom trust store file in Dynatrace Active Gate:

To configure ActiveGate to use a custom trust store file Copy the trusted.jks file to the SSL directory. Add the following entries to the config/custom.properties file:

[collector]
trustedstore = trusted.jks
trustedstore-password = trusted
trustedstore-type = JKS
