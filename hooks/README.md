# Git hooks

This folder contains optional [Git hooks](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks) that may be installed in a local clone of the repository.

## Installation

To install a hook, simply create a symlink to the hook file in the `.git/hooks` directory.

For example, execute the following from the root directory of the repository to install the pre-commit hook:

```bash
ln -s ../../hooks/pre-commit .git/hooks/pre-commit
```

> **Note:** the first argument to `ln` is the **target** of the link and the second argument is the **link** that you want to create. The path of the target must either be absolute or relative to the location of the link that is being created. For this reason, the target path in the above example is prefixed with `../..` because the link is created in `.git/hooks`, that means, two levels down from the root directory of the repository.

## Hooks

### pre-commit

The pre-commit hook runs immediately after running `git commit` (before the editor for typing a commit message appears). If the hook script exits with a n non-zero exit code, the commit is aborted.

The provided pre-commit hook runs all the YAML file validations that are also run by the [_Validate YAML files_](../.github/workflows/validate-yaml-files.yml) GitHub Actions workflow. This has the advantage that errors are detected and fixed before anything is pushed to GitHub which results in fewer failed GitHub Actions runs and a less polluted Git commit history.

To bypass the execution of the pre-commit hook for individual commits, add the `-n` or `--no-verify` options to the `git commit` command.
