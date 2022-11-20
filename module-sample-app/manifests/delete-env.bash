#!/usr/bin/env bash -ex

kubectl delete configmap config-repo-movies-api

kubectl delete secret mongodb-server-credentials

kubectl delete secret  mongodb-credentials


# Delete all resources
kubectl delete -f ../k3s
# kubectl delete -f ../k3s-dashboard