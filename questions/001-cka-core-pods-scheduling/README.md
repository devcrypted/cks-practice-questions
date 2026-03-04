# CKA: Core Concepts - Pods and Scheduling (001)

## Scenario

A deployment named `nginx-ssd` has been created, but its pods are stuck in a `Pending` state. The deployment is configured to schedule pods only on nodes with Solid State Drives (SSD).

## Tasks

1. Identify why the pods for the `nginx-ssd` deployment are `Pending`.
2. Fix the issue by adding the appropriate label (`disk=ssd`) to the node named `practice-cluster-control-plane`.
3. Ensure the pod transitions to the `Running` state.

## Getting Started

First, prepare the environment by running the setup script from this question's directory:

```bash
python start.py start 001
```

## Verification

Once you have completed the tasks, verify your solution:

```bash
python start.py verify
```
