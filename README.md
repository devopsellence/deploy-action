# devopsellence deploy-action

GitHub Action to build, push, and deploy your app using [devopsellence](https://www.devopsellence.com).

## Prerequisites

Your repository must have a `Dockerfile`. That's it.

## Setup

**1. Create your project and get a token**

Visit **[devopsellence.com/setup/github-actions](https://www.devopsellence.com/setup/github-actions)** — sign in with your email, name your project, and you'll get a deploy token and a ready-to-use workflow snippet. No CLI required.

Alternatively, if you have the CLI installed:

```bash
devopsellence init
devopsellence token --name github-actions
```

**2. Add the token to GitHub**

Go to your repository → **Settings** → **Secrets and variables** → **Actions**, and create a new secret named `DEVOPSELLENCE_TOKEN` with the token value.

**3. Add the workflow**

Create `.github/workflows/deploy.yml` in your repository.

If you used the web setup, copy the pre-filled snippet shown there. Otherwise:

```yaml
on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: devopsellence/deploy-action@v1
        with:
          token: ${{ secrets.DEVOPSELLENCE_TOKEN }}
          project: your-project
```

Or if you have a committed `devopsellence.yml`, the `organization` and `project` inputs can be omitted — they'll be read from the config file.

That's it. Every push to `main` will build your Docker image, push it to the registry, and deploy it.

## GitHub-managed env vars and secrets

If you do not want to commit runtime config, the action can sync GitHub values at deploy time:

- Add a repository variable named `DEVOPSELLENCE_ENV_VARS`
- Add a repository secret named `DEVOPSELLENCE_SECRETS`
- Pass them through in the workflow `env:` block

Both values must be JSON. A flat object applies to every configured runtime service; a scoped object can use `all`, `web`, and `worker`.

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    env:
      DEVOPSELLENCE_ENV_VARS: ${{ vars.DEVOPSELLENCE_ENV_VARS }}
      DEVOPSELLENCE_SECRETS: ${{ secrets.DEVOPSELLENCE_SECRETS }}
    steps:
      - uses: actions/checkout@v4
      - uses: devopsellence/deploy-action@v1
        with:
          token: ${{ secrets.DEVOPSELLENCE_TOKEN }}
          project: your-project
```

Example values:

```json
{
  "all": {
    "RAILS_ENV": "production"
  },
  "worker": {
    "QUEUE": "critical"
  }
}
```

```json
{
  "all": {
    "DATABASE_URL": "postgres://..."
  },
  "worker": {
    "REDIS_URL": "redis://..."
  }
}
```

Secrets synced this way are stored as managed environment secrets and are exposed automatically in desired state for the matching service. You do not need to add them to `secret_refs` in `devopsellence.yml`.

## Inputs

| Input | Required | Description |
|-------|----------|-------------|
| `token` | yes | API token from `devopsellence token` or the web setup page |
| `organization` | no | Organization name. Required if no `devopsellence.yml` is committed |
| `project` | no | Project name. Required if no `devopsellence.yml` is committed |
| `environment` | no | Environment name override (default: `production`) |

## Releasing

Releases publish on semver tags like `v1.0.0`. The baked CLI version lives in `CLI_VERSION`.

To prep the next release locally:

```bash
mise run release -- v1.0.0 v0.1.0
```

That updates `action.yml`, writes `CLI_VERSION`, creates a release commit, tags `v1.0.0`, and moves the major tag (`v1`). Then push:

```bash
git push origin master
git push origin v1.0.0
git push --force origin v1
```

To republish an existing semver tag intentionally:

```bash
mise run release -- --force-existing-tag v1.0.0 v0.1.0
git push origin master
git push --force origin v1.0.0
git push --force origin v1
```
