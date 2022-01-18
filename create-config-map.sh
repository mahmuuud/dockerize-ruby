#!/usr/bin/env bash
kubectl create configmap $1 --from-file $2
kubectl get configmap $1 -o yaml