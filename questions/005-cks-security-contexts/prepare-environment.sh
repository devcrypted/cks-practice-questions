#!/bin/bash
kubectl delete ns q5-security --ignore-not-found=true
kubectl create ns q5-security

cat <<EOF | kubectl apply -n q5-security -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: secure-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: secure-app
  template:
    metadata:
      labels:
        app: secure-app
    spec:
      containers:
      - name: app
        image: busybox
        command: ["sleep", "3600"]
EOF

echo "Environment prepared in namespace 'q5-security'."
