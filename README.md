# devops-helm-umbrella-subcharts

A Helm umbrella chart that deploys a small `api` and `worker` pair from two
local subcharts. It shows how to share settings through `global` values, switch
components on and off with `condition`, and keep per-environment overrides in
their own files.

## Layout

    chart/                 umbrella chart (no templates of its own)
      charts/api/          HTTP service
      charts/worker/       background consumer
      values.yaml          defaults and global values
      values-dev.yaml
      values-prod.yaml

## Usage

    helm dependency list chart
    helm template demo chart -f chart/values-dev.yaml
    helm template demo chart --set worker.enabled=false

## Validation

    make validate

Runs `helm lint`, renders each environment through `kubeconform`, and checks
the toggles. Requires `helm` and `kubeconform` on the PATH.
