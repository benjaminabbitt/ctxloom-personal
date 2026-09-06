---
tags:
  - just
  - tooling
  - containers
  - docker
  - podman
  - overlay-pattern
  - top
content_hash: sha256:611f64e564b634c6671fddfce0a8900226972ddb8b1f36c867e12547248d9fc1
---
# just: Container Overlay Pattern

When a recipe needs a specific containerized toolchain (pinned `protoc`, sealed network, reproducible build environment), the host justfile delegates into a container; inside the container, a different justfile is mounted over the host's and runs the actual command. Same `just build` works in both contexts. No duplicate target names. No `container-build` vs `build` split.

## The setup

{{=<% %>=}}
```just
# Host /justfile
TOP := `git rev-parse --show-toplevel`

_run +ARGS:
    docker run --rm \
      -v {{TOP}}:/workspace \
      -v {{TOP}}/justfile.container:/workspace/justfile:ro \
      -w /workspace build-env:latest just {{ARGS}}

build: (_run "build")
test:  (_run "test")
```
<%={{ }}=%>

{{=<% %>=}}
```just
# /justfile.container
TOP := `git rev-parse --show-toplevel`

build:
    cargo build --manifest-path {{TOP}}/Cargo.toml --release

test:
    cargo test --manifest-path {{TOP}}/Cargo.toml
```
<%={{ }}=%>

## Why this works

{{=<% %>=}}
The load-bearing line is `-v {{TOP}}/justfile.container:/workspace/justfile:ro`. The bind mount obscures `justfile` inside the container with `justfile.container`. Inside the container, `just build` resolves to the container's `build` recipe (which runs the actual cargo command). On the host, `just build` resolves to the delegation that spawns the container.
<%={{ }}=%>

## Concerns separated

- Host file orchestrates the container, never the build.
- Container file runs the build, never knows about the container.
- Build-logic changes touch only the container file.
- Container-orchestration changes touch only the host file.

## Real-world example

Angzarr uses this pattern across coordinators (aggregate, saga, projector, process-manager, stream, log, grpc-gateway). Each coordinator has a local `justfile` and `justfile.container`. The root justfile composes them via `mod`, so `just aggregate build` works from the repo root and `just build` works from inside the coordinator directory or inside the container, all producing the same result.

## Anti-Patterns

- `_run` that runs on the host instead of in a container: defeats the overlay.
- Container justfile that re-invokes `docker run`: docker-in-docker by accident.
- Mounting the container justfile over the host's read-write rather than `:ro`: the container build accidentally edits the host file.
- Recipe-argument escaping ceremony: just's `+ARGS` preserves multi-word args through the delegation without `$$`-escaping. Use it.
