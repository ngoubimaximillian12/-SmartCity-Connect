# Branching Strategy

This repository follows a lightweight Git flow model.

## Branches
- `main`: production-ready, tagged releases only
- `develop`: integration branch for completed work
- `feature/*`: feature branches for new work
- `hotfix/*`: urgent fixes against `main`

## Workflow
1. Branch from `develop`: `feature/<short-description>`
2. Open a PR into `develop`
3. Merge to `main` for releases and tag
4. Use `hotfix/<issue>` for urgent production fixes
