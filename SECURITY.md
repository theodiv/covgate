# Security Policy

## Supported Versions

Only the latest released version of Covgate receives security fixes.
Older releases are not patched.

## Reporting a Vulnerability

Report vulnerabilities privately; never open a public issue for one.

- **GitHub private vulnerability reporting** (preferred): open a draft
  advisory on the
  [security advisories page](https://github.com/theodiv/covgate/security/advisories/new).
- **Email**: `theodiv@gmail.com`.

## Disclosure Process

1. The maintainer acknowledges the report within **72 hours**.
2. The maintainer confirms or declines the report and assesses its
   severity within **7 days** of receiving it.
3. The fix is developed and tested in the advisory's temporary private fork.
4. Disclosure is coordinated with the reporter, targeting **30 days** from
   confirmation; complex issues may take longer.
5. The patched release and the advisory are published together.
6. The advisory credits the reporter unless anonymity is requested.

## Out of Scope

- Defects in coverage.py; report them on the
  [coverage.py issue tracker](https://github.com/coveragepy/coveragepy/issues).
- Defects in pytest-cov; report them on the
  [pytest-cov issue tracker](https://github.com/pytest-dev/pytest-cov/issues).
- A coverage report or `pyproject.toml` changed by someone with write access
  to the project.
