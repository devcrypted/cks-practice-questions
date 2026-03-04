#!/bin/bash
# Verifies the user's solution

echo "Verifying solution..."

# 1. Check if the label exists on the node
LABEL_CHECK=$(kubectl get node practice-cluster-control-plane -o jsonpath='{.metadata.labels.disk}' 2>/dev/null)

if [ "$LABEL_CHECK" != "ssd" ]; then
    echo "FAIL: The node 'practice-cluster-control-plane' does not have the label 'disk=ssd'."
    exit 1
fi

# 2. Check if the pod is running
POD_STATUS=$(kubectl get pods -l app=nginx-ssd -o jsonpath='{.items[0].status.phase}' 2>/dev/null)

if [ "$POD_STATUS" != "Running" ]; then
    echo "FAIL: The pod is not in the 'Running' state. Current state: ${POD_STATUS:-unknown}"
    exit 1
fi

echo "PASS: Question was solved successfully! Marks: 10/10."
exit 0
