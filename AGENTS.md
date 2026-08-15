# Repository Instructions

## Alias changes

- Keep shared shortcuts synchronized across `aliases.sh`, `aliases.ps1`, and the shortcut table in `README.md`.
- Validate the relevant shell files and confirm that new shortcuts forward their arguments correctly.
- After finishing an alias change, update the current machine's installed aliases before declaring the task complete. On Unix-like systems, run the repository's `install.sh`; when the change is not yet on `main`, point `PORTABLE_ALIASES_URL` at the pushed current branch or install from the local checkout. On Windows, run `install.ps1` from the corresponding published revision.

## Finishing work

- After completing and validating a task, commit all task-related changes and push the current branch to `origin`.
- Stage files explicitly and do not include unrelated or generated files in the commit.
- Report the commit hash, branch, push result, validation performed, and installed-alias update in the final response.
