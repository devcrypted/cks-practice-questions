#!/bin/bash
kubectl delete ns q2-networking --ignore-not-found=true
kubectl create ns q2-networking

cat <<EOF | kubectl apply -n q2-networking -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webapp
spec:
  replicas: 2
  selector:
    matchLabels:
      app: webapp
      tier: frontend
  template:
    metadata:
      labels:
        app: webapp
        tier: frontend
    spec:
      containers:
      - name: nginx
        image: nginx:alpine
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: webapp-service
spec:
  selector:
    app: webserver # Intentional mismatch
    tier: frontend
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
EOF
echo "Environment prepared in namespace 'q2-networking'."
