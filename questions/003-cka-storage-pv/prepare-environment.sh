#!/bin/bash
kubectl delete pod data-pod --ignore-not-found=true
kubectl delete pvc app-data-pvc --ignore-not-found=true
kubectl delete pv app-data-pv --ignore-not-found=true
echo "Environment cleaned and ready. You may proceed with the tasks."
