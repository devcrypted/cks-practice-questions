#!/bin/bash
echo "Verifying solution..."

# Get the pod spec for the deployment
NON_ROOT=$(kubectl get deployment secure-app -n q5-security -o jsonpath='{.spec.template.spec.securityContext.runAsNonRoot}' 2>/dev/null)
USER_ID=$(kubectl get deployment secure-app -n q5-security -o jsonpath='{.spec.template.spec.securityContext.runAsUser}' 2>/dev/null)

if [ "$NON_ROOT" != "true" ]; then
    echo "FAIL: Deployment 'secure-app' does not have 'runAsNonRoot: true' in its pod securityContext."
    exit 1
fi

if [ "$USER_ID" != "1000" ]; then
    echo "FAIL: Deployment 'secure-app' does not have 'runAsUser: 1000' in its pod securityContext."
    exit 1
fi

POD_STATUS=$(kubectl get pods -l app=secure-app -n q5-security -o jsonpath='{.items[0].status.phase}' 2>/dev/null)
if [ "$POD_STATUS" != "Running" ]; then
    echo "FAIL: The new pod is not in the 'Running' state."
    exit 1
fi

echo "PASS: Question was solved successfully! Marks: 10/10."
exit 0
