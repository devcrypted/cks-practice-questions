# CKA: Networking - Services (001)

## Scenario

A small web application is deployed in the `q2-networking` namespace. However, users are complaining that the service `webapp-service` is not routing traffic to the application pods.

## Tasks

1. Investigate the `webapp-service` and the `webapp` deployment in the `q2-networking` namespace.
2. Fix the misconfiguration so that the service successfully routes traffic to the pods.
3. Verify that the service has active endpoints.

## Getting Started

Prepare the environment:

```bash
python start.py start 002
```

## Verification

Verify your solution:

```bash
python start.py verify
```
