#!/bin/bash
set -e

# Required Envs:
# GITHUB_URL: URL of the repository (e.g. https://github.com/my/repo)
# GITHUB_TOKEN: Runner registration token (from Settings -> Actions -> Runners -> New)
# RUNNER_NAME: Name of this runner (default: samsung-docker-runner)
# RUNNER_LABELS: Labels for this runner (default: samsung-runner)

GITHUB_URL=${GITHUB_URL:-"https://github.com/dhkimxx/executorch"}
RUNNER_NAME=${RUNNER_NAME:-"samsung-docker-runner"}
RUNNER_LABELS=${RUNNER_LABELS:-"samsung-runner"}

if [ -z "$GITHUB_TOKEN" ]; then
    echo "Error: GITHUB_TOKEN is not set."
    exit 1
fi

if [ -f ".runner" ]; then
    echo "Runner already configured. Skipping configuration."
else
    echo "Configuring GitHub Runner..."
    ./config.sh --url "${GITHUB_URL}" --token "${GITHUB_TOKEN}" --name "${RUNNER_NAME}" --labels "${RUNNER_LABELS}" --unattended --replace
fi

echo "Starting GitHub Runner..."
./run.sh
