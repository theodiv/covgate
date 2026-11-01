# Contributing to Covgate

This document defines the standards, workflow, and expectations for all
submissions.

## Code of Conduct

Every participant follows the [Code of Conduct](CODE_OF_CONDUCT.md).

## Development Setup

```bash
python3 -m venv --upgrade-deps .venv
source .venv/bin/activate
pip install -e . --group dev
pre-commit install
```

Activate `.venv` in each new terminal; the commands below assume it is active.

The pre-commit hooks call the tools in `.venv`; a different environment
name leaves them unable to run. `--upgrade-deps` provides pip 25.1 or later,
which `--group` needs.

## Toolchain

| Tool | Role |
|---|---|
| Hatchling | Build backend; reads the version from `src/covgate/__init__.py` |
| Ruff | Lint and format |
| mypy | Strict type checks of `src/` and `tests/` |
| pytest and pytest-cov | Tests and branch coverage |
| pre-commit | Hygiene hooks, Ruff, and mypy on every commit |

All tool configuration lives in `pyproject.toml`. The `dev` dependency group
pins each tool with `==`, so the hooks, the gates, and CI run one version. A
pin moves only through a Dependabot PR or a `chore`.

## Quality Gates

Every gate must pass in CI. Before opening a PR, run them all:

```bash
ruff check .
ruff format --check .
mypy src/ tests/
pre-commit run --all-files
pytest --cov
```

The test gate requires 95% global branch coverage (`fail_under` in
`[tool.coverage.report]`). `pre-commit run --all-files` reads tracked files
only; pass a file not yet staged with `--files`.

Apply the fixes with:

```bash
ruff check --fix .
ruff format .
```

## Testing Standards

- Tests must mirror `src/`: `tests/<domain>/test_<module>.py` for a domain
  module, `tests/test_<module>.py` for a top-level module.
- Every bug fix must add a regression test that fails on the unfixed code.
- Tests must assert outcomes (outputs, lengths, exit codes, stderr lines), not
  that an internal call happened.
- Tests must not reach the network beyond `127.0.0.1`, use real credentials,
  or write outside pytest's temporary directories.
- Test code must be annotated as fully as `src/`.

Run one test module while working:

```bash
pytest tests/test_init.py
```

## Pull Request Process

1. Fork the repository and create a branch from `main`, named
   `<type>/<short-kebab-summary>`.
2. Keep each PR to one change, with its tests and its documentation.
3. Add an entry under `[Unreleased]` in `CHANGELOG.md` for every
   caller-visible change.
4. Run every gate in Quality Gates.
5. Open the PR from the template: state the why in the description, mark
   exactly one type, and complete the checklist.

Report security defects through [SECURITY.md](SECURITY.md), never in a public
issue or PR.

## Commit Convention

Every PR lands as one squash merge, so its title becomes the commit subject on
`main` and must follow
[Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/):

```text
<type>(<scope>)[!]: <summary>
```

- Types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `perf`, `ci`.
- Scopes, optional: `model`, `settings`, `disk`, `report`, `render`, `cli`,
  `build`.
  A CI change takes the `ci` type with no scope.
- The summary must be imperative and lowercase, with no trailing period.
- A title must not exceed 68 characters, `<type>(<scope>)` and `!` included,
  so that GitHub's `(#N)` suffix still fits.
- A title must not hold an issue link. `Closes #N` goes on its own line in the
  description, only when the PR resolves that issue.
- A breaking change adds `!` after the scope, and the description states what
  callers must change in a `**Breaking:**` line.

CI rejects a title with an unlisted type or scope, or over the length limit.
