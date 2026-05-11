# JFrog Example

This is a small JFrog demo project. It runs a tiny Node.js service and a local JFrog Artifactory OSS instance, then publishes the app package into Artifactory. It also includes a minimal Frogbot GitHub Actions workflow for pull request security scanning.

The local Artifactory demo does not require a JFrog Cloud account. The Frogbot demo runs in GitHub and requires JFrog/Xray credentials.

## Requirements

- Node.js 22+
- Docker
- Docker Compose
- curl

## Run The App

```bash
make install
make test
make start-app
```

Open:

```text
http://localhost:3000
```

## Run Local JFrog

```bash
make start-jfrog
```

Artifactory runs at:

```text
http://localhost:8082
```

For a fresh local Artifactory OSS container, the demo uses:

```text
username: admin
password: password
```

## Publish The Project To JFrog

```bash
make publish
```

That command:

1. Runs the Node.js test.
2. Creates `dist/jfrog-example.tar.gz`.
3. Uses local Artifactory with local PostgreSQL.
4. Uses the built-in local repository named `example-repo-local`.
5. Uploads the package to Artifactory.
6. Tags the uploaded artifact with `build.name` and `build.number` metadata.

After publishing, check the artifact in the UI:

```text
http://localhost:8082/ui/repos/tree/General/example-repo-local/jfrog-example/local-1
```

## Project Structure

```text
.
|-- docker-compose.yml
|-- Dockerfile
|-- Makefile
|-- scripts/
|   |-- init-artifactory.sh
|   |-- package-app.sh
|   |-- publish-to-artifactory.sh
|   `-- wait-for-artifactory.sh
|-- src/
|   `-- index.js
`-- test/
    `-- index.test.js
```

## What This Demonstrates

- A normal application artifact.
- A local Artifactory repository.
- Uploading artifacts to JFrog.
- Storing build metadata on an uploaded artifact.
- A Frogbot workflow that scans pull requests in GitHub.

## Frogbot GitHub Setup

Frogbot runs in GitHub Actions. It does not run inside the Node.js app and it does not run from the local Artifactory OSS container.

This repo includes:

```text
.github/workflows/frogbot.yml
```

To make it work from a new GitHub repository:

1. Create a new GitHub repository.
2. Push this project to GitHub.
3. In GitHub, go to `Settings > Secrets and variables > Actions`.
4. Create these repository secrets:

```text
JF_URL
JF_ACCESS_TOKEN
```

`JF_URL` is your JFrog Platform URL, for example:

```text
https://your-company.jfrog.io
```

`JF_ACCESS_TOKEN` is a JFrog access token that can use JFrog security scanning.

5. Go to `Settings > Actions > General`.
6. Enable GitHub Actions for the repository.
7. Under workflow permissions, allow actions to create pull request comments.
8. Create a new branch.
9. Make a small dependency change.
10. Open a pull request into `main`.

Frogbot should run on the pull request and report dependency security findings.

This project intentionally uses `lodash@4.17.20` so the scan has a dependency to inspect. Do not copy that version into production code.

## Troubleshooting

If `http://localhost:8082` shows an empty page, Artifactory probably failed during startup. This demo creates local `artifactory-var/etc/security/master.key` and `artifactory-var/etc/security/join.key` files before starting the container because Artifactory needs those keys to boot.

Restart with:

```bash
docker compose down
make start-jfrog
```

Current Artifactory versions also require PostgreSQL by default. The `docker-compose.yml` file starts a local `postgres` container for that.
