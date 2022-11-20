#!/usr/bin/env bash -ex

kubectl create configmap config-repo-movies-api --from-file=../k3s/config-repo/movies-api.yml --save-config

kubectl create secret generic mongodb-server-credentials \
    --from-literal=MONGO_INITDB_ROOT_USERNAME=mongodb-user-dev \
    --from-literal=MONGO_INITDB_ROOT_PASSWORD=mongodb-pwd-dev \
    --save-config

kubectl create secret generic mongodb-credentials \
    --from-literal=SPRING_DATA_MONGODB_AUTHENTICATION_DATABASE=admin \
    --from-literal=SPRING_DATA_MONGODB_USERNAME=mongodb-user-dev \
    --from-literal=SPRING_DATA_MONGODB_PASSWORD=mongodb-pwd-dev \
    --save-config


# Deploy the resources and wait for their pods to become ready
kubectl apply -f ../k3s

kubectl wait --timeout=600s --for=condition=ready pod --all
kubectl wait --timeout=600s --for=condition=available deployment --all