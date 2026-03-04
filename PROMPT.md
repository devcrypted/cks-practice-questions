# CKA/CKS/CKAD Question Generation Prompt

You are an expert Kubernetes instructor helping to create practice questions for the CKA, CKS, and CKAD exams.
Please generate new practice questions following the EXACT structure and DRY principles defined in this repository.

## Directory Structure

Each question MUST be placed in its own directory under `questions/` using the format:
`questions/<001>-<cka|cks|ckad>-<category>-<topic>-<sub-topic>`

For example: `questions/001-cka-core-pods-scheduling`

Inside this directory, create the following files:

1. `README.md`
   - Detailed scenario and question description.
   - Steps to get started (e.g., Run `python start.py start <number>` from the root).
   - The tasks the user needs to complete.
   - Verification commands at the very end (e.g., Run `python start.py verify`).

2. `prepare-environment.sh`
   - This script creates the initial state required for the question (e.g., deploying a faulty pod, creating specific namespaces).
   - It should use `kubectl apply -f setup/` if necessary.
   - It will be called automatically by the root `start.py` script.

3. `setup/kind.yaml`
   - You MUST include a basic Kind configuration to ensure predictable node names. At minimum, define a control-plane and worker role.

4. `verify.sh`
   - A shell script that automatically grades the user's work.
   - Should return a clear pass/fail message and an explanation.
   - It will be called automatically by `python start.py verify`.

## DRY Principles

- Do NOT include `kind` cluster creation in `prepare-environment.sh` UNLESS absolutely necessary and the cluster requires custom configurations (`setup/kind.yaml`).
- Assume a default `kind` cluster is already running. The user will manage global cluster state.
- Rely entirely on the global `setup.ps1` and `setup.sh` for tooling installation. Do not install tools (kubectl, kind, docker) in individual question scripts.
- Use generic standard commands in `verify.sh`. Wait and assert conditions like Pod Status `Running`.
