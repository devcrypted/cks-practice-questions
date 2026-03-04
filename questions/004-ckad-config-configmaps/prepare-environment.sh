#!/bin/bash
kubectl delete ns q4-configmaps --ignore-not-found=true
kubectl create ns q4-configmaps

cat <<EOF | kubectl apply -n q4-configmaps -f -
apiVersion: v1
kind: Pod
metadata:
  name: color-app
spec:
  containers:
  - name: app
    image: busybox
    command: ['sh', '-c', 'if [ -z "\$APP_COLOR" ]; then echo "Missing APP_COLOR"; exit 1; else echo "Color is \$APP_COLOR"; sleep 3600; fi']
    env:
    - name: APP_COLOR
      valueFrom:
        configMapKeyRef:
          name: app-config
          key: color
EOF

echo "Environment prepared in namespace 'q4-configmaps'. The color-app pod should be failing."
