#!/bin/bash
echo "Verifying solution..."

# Check configmap exists
CM_VAL=$(kubectl get cm app-config -n q4-configmaps -o jsonpath='{.data.color}' 2>/dev/null)
if [ -z "$CM_VAL" ]; then
    echo "FAIL: ConfigMap 'app-config' with key 'color' does not exist in namespace 'q4-configmaps'."
    exit 1
fi

# Check pod is running
POD_STATUS=$(kubectl get pod color-app -n q4-configmaps -o jsonpath='{.status.phase}' 2>/dev/null)
if [ "$POD_STATUS" != "Running" ]; then
    echo "FAIL: Pod 'color-app' is not Running. Status: ${POD_STATUS:-unknown}"
    exit 1
fi

echo "PASS: Question was solved successfully! Marks: 10/10."
exit 0
