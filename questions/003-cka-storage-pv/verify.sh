#!/bin/bash
echo "Verifying solution..."

# 1. Check PV
PV_CAP=$(kubectl get pv app-data-pv -o jsonpath='{.spec.capacity.storage}' 2>/dev/null)
if [ "$PV_CAP" != "1Gi" ]; then
    echo "FAIL: PersistentVolume 'app-data-pv' is missing or has incorrect capacity."
    exit 1
fi

# 2. Check PVC status
PVC_STATUS=$(kubectl get pvc app-data-pvc -o jsonpath='{.status.phase}' 2>/dev/null)
if [ "$PVC_STATUS" != "Bound" ]; then
    echo "FAIL: PersistentVolumeClaim 'app-data-pvc' is not Bound. Wait a moment and try again, or check events."
    exit 1
fi

# 3. Check Pod Mount
POD_MOUNT=$(kubectl get pod data-pod -o jsonpath='{.spec.volumes[?(@.persistentVolumeClaim.claimName=="app-data-pvc")].name}' 2>/dev/null)
if [ -z "$POD_MOUNT" ]; then
    echo "FAIL: Pod 'data-pod' does not have the PVC mounted."
    exit 1
fi

POD_STATUS=$(kubectl get pod data-pod -o jsonpath='{.status.phase}' 2>/dev/null)
if [ "$POD_STATUS" != "Running" ]; then
    echo "FAIL: Pod 'data-pod' is not Running. Status: $POD_STATUS"
    exit 1
fi

echo "PASS: Question was solved successfully! Marks: 10/10."
exit 0
