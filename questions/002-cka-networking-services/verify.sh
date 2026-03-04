#!/bin/bash
echo "Verifying solution..."
ENDPOINTS=$(kubectl get endpoints webapp-service -n q2-networking -o jsonpath='{.subsets[*].addresses[*].ip}' 2>/dev/null)

if [ -z "$ENDPOINTS" ]; then
    echo "FAIL: The service 'webapp-service' does not have any endpoints. Check the selectors."
    exit 1
fi

echo "PASS: Question was solved successfully! Marks: 10/10."
exit 0
