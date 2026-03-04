# CKS: Cluster Setup - Security Context (001)

## Scenario

You have a deployment named `secure-app` in the `q5-security` namespace. For compliance reasons, the containers in this deployment must not run as the `root` user.

## Tasks

1. Update the `secure-app` deployment in the `q5-security` namespace so that its pod spec enforces `runAsNonRoot: true` and sets the `runAsUser` to `1000`.
2. Apply the changes and wait for the new pods to become completely ready.
3. Ensure the old pods (running as root) are terminated by checking rollout status.

## Getting Started

Prepare the environment:

```bash
python start.py start 005
```

## Verification

Verify your solution:

```bash
python start.py verify
```
