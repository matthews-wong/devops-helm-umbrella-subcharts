#!/usr/bin/env bash
# Each component must be removable on its own, and global values must reach both.
set -euo pipefail

CHART="$(dirname "$0")/../chart"

deployments() {
  helm template t "$CHART" "$@" | awk '/^kind: Deployment/ {n++} END {print n+0}'
}

fail() { echo "FAIL: $*"; exit 1; }

[[ "$(deployments)" == 2 ]] || fail "expected 2 deployments by default"
[[ "$(deployments --set worker.enabled=false)" == 1 ]] || fail "worker.enabled=false did not remove worker"
[[ "$(deployments --set api.enabled=false)" == 1 ]] || fail "api.enabled=false did not remove api"
[[ "$(deployments --set api.enabled=false --set worker.enabled=false)" == 0 ]] || fail "both disabled still renders deployments"
echo "ok:   component toggles"

envs="$(helm template t "$CHART" --set global.environment=staging | grep -c 'value: "staging"')"
[[ "$envs" == 2 ]] || fail "global.environment reached $envs of 2 components"
echo "ok:   global.environment propagates to both subcharts"
