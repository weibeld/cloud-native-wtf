# Git hooks

This directory contains optional [Git hooks](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks) that may be installed in a local clone of the repository.

## Installation

To install a hook, create a symlink in the `.git/hooks` directory pointing to the desired hook file.

For example:

```bash
ln -s ../../hooks/pre-commit .git/hooks/pre-commit
```

The above creates the symlink `.git/hooks/pre-commit` pointing to the [`pre-commit`](pre-commit) hook file. This effectively installs and enables the pre-commit hook.

> **Important:** the path for the first argument of `ln` (the target of the symlink) must be relative to the location of the created link and **not** relative to the current working directory from which the command is executed.

## Hooks

### pre-commit

> A pre-commit hook runs after running `git commit` and before the editor window for typing a commit message occurs. If this hook exits with a non-zero exit code, the commit is aborted. The execution of the pre-commit hook can be disabled for individual commits with the `-n` or `--no-verify` flags.

The provided [`pre-commit`](pre-commit) hook performs the same operations as the [`validate`](../.github/workflows/validate.yml) GitHub Actions workflow. This allows detecting errors before committing and pushing, thus accelerating the feedback cycle, and also keeping the Git history clean.
