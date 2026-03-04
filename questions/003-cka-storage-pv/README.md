# CKA: Storage - Persistent Volumes (001)

## Scenario

You have been asked to provision persistent storage for a new pod that requires data to survive container restarts.

## Tasks

1. Create a `PersistentVolume` named `app-data-pv` with a capacity of `1Gi` using `hostPath` at `/tmp/app-data`. Provide `ReadWriteOnce` access mode.
2. Create a `PersistentVolumeClaim` named `app-data-pvc` that requests `500Mi` of storage with `ReadWriteOnce` access mode.
3. Create a pod named `data-pod` using the `busybox` image. The pod should run the command `sleep 3600`.
4. Mount the PVC to the pod at the path `/mnt/data`.

## Getting Started

Run the setup script to ensure a clean state:

```bash
python start.py start 003
```

## Verification

Verify your solution:

```bash
python start.py verify
```
