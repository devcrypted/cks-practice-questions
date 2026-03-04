# CKAD: Configuration - ConfigMaps (001)

## Scenario

A pod named `color-app` has been deployed in the `q4-configmaps` namespace, but it keeps failing and crashing. It appears to be missing some required configuration.

## Tasks

1. Investigate the `color-app` pod to find out why it's failing.
2. Create the missing `ConfigMap` named `app-config` with a key `color` and value `blue` in the `q4-configmaps` namespace.
3. Ensure the pod is successfully running after the ConfigMap is created (you may need to recreate the pod if it doesn't recover automatically).

## Getting Started

Prepare the environment:

```bash
python start.py start 004
```

## Verification

Verify your solution:

```bash
python start.py verify
```
