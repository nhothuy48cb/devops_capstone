#!/usr/bin/env bash

HADOLINT_FILE=https://github.com/hadolint/hadolint/releases/download/v2.10.0/hadolint-Linux-x86_64

test -e ./bin/hadolint ||
  {
    wget -qO ./bin/hadolint "${HADOLINT_FILE}"
    chmod +x ./bin/hadolint
  }

echo "./bin/hadolint: $(./bin/hadolint --version)"
