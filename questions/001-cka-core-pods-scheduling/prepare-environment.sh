#!/bin/bash
# Prepares the environment for the scheduling question

# Clean up existing resources if they exist
kubectl delete deployment nginx-ssd --ignore-not-found=true
kubectl label node practice-cluster-control-plane disk- 2>/dev/null || true

echo "Deploying the failing deployment..."

cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-ssd
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx-ssd
  template:
    metadata:
      labels:
        app: nginx-ssd
    spec:
      containers:
      - name: nginx
        image: nginx:1.24.0
      nodeSelector:
        disk: ssd
EOF

# Wait a moment to ensure it's applied
sleep 2
echo "Environment preparation complete. The pod should be in Pending state."
