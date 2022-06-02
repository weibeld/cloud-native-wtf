# Scripts

This directory contains scripts that are executed by the GitHub Actions workflows defined in [`.github/workflows`](../.github/workflows).

## Contract

The scripts in this directory must satisfy the following contract:

- When the operation implemented by a script fails, the script must exit with a non-zero exit code, otherwise, it must exit with a zero exit code.
- If a script performs the same operation on multiple objects in a loop (e.g. files), the script should always perform the operation on all objects before exiting (even if the operation fails on some of the objects), rather than exiting on the first failed operation.
  - This allows the user to see all errors in a single run of the workflow, rather than incrementally discovering them through multiple workflow runs.
- The script must write normal output to `stdout` and error messages to `stderr`.
- Each script must run in a container. When a script is started, it must check whether it is running in a container, and if not, it must start this container and launch itself in this container.
  - This is implemented by the `ensure_container` function in the [`util.sh`](util.sh) file (see below).
- Each script must be executed from the root directory of the repository. If a script is executed from a different directory, it should fail.
- Each script may source the [`util.sh`](util.sh) file, which contains utilities that are used by multiple scripts.

## Notes

### Non-container execution

A script using the `ensure_container` function of [`util.sh`](util.sh) may be executed directly on the host system (i.e. not in a container) as follows:

```bash
OS_ENV=container scripts/script.sh
```

This tricks the script into believing that it is running in a container. This works because the `ensure_container` function sets the `OS_ENV=container` variable when starting a container, and at the beginning of the execution it checks this variable to detect whether it is running in a container or not.

However, when doing this, all the dependencies of the script must be installed on the host system, and, in general, the script may behave differently than when run in its container.
