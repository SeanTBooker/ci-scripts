#!/bin/bash

set -exuo pipefail

if [[ -z "$BUILDKITE" ]]; then
  echo "not running in CI, nothing to do"
  exit 0
fi

# This script checks if we should do a docker build, and if so adds a step in
# the build pipeline to do so.

CURRENT_SHA=$(git rev-parse HEAD)
MASTER_SHA=$(git rev-parse origin/master)

# If this commit matches an exact tag, or HEAD is origin/master, or the commit
# message includes /build-docker, kick off the docker step.
if git describe --tags --exact-match || [[ "$CURRENT_SHA" == "$MASTER_SHA" ]] || [[ "$BUILDKITE_MESSAGE" =~ /build-docker ]]; then
  buildkite-agent pipeline upload .buildkite/image-release-pipeline.yml
fi
