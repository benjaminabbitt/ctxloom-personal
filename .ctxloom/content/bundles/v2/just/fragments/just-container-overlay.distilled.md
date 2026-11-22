---
source_sha256: cf9dc08b30ebd4c8bfa82e27bc7658d41e51df220860fba713490d6f5b22b661
---
# just: Container Overlay Pattern

- Use when a recipe needs a pinned containerized toolchain (e.g. pinned `protoc`, sealed network, reproducible build env).
- Host `/justfile` delegates into a container; inside it, a different justfile is mounted over the host's and runs the real command. Same `just build` works in both contexts. No duplicate target names, no `container-build` vs `build` split.

## Setup

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

```just
# /justfile.container
TOP := `git rev-parse --show-toplevel`

build:
    cargo build --manifest-path {{TOP}}/Cargo.toml --release

test:
    cargo test --manifest-path {{TOP}}/Cargo.toml
```

## Why it works

- Load-bearing line: `-v {{TOP}}/justfile.container:/workspace/justfile:ro`. The bind mount shadows `justfile` in the container with `justfile.container`.
- In container: `just build` runs the container's `build` recipe (actual cargo command).
- On host: `just build` runs the delegation that spawns the container.

## Concerns separated

- Host file orchestrates the container; never the build.
- Container file runs the build; never knows about the container.
- Build-logic changes touch only the container file.
- Container-orchestration changes touch only the host file.

## Real-world example

Angzarr uses this across coordinators (aggregate, saga, projector, process-manager, stream, log, grpc-gateway). Each has a local `justfile` and `justfile.container`. Root justfile composes them via `mod`, so `just aggregate build` works from repo root, and `just build` works from inside the coordinator directory or inside the container, all yielding the same result.

## Anti-patterns

- `_run` executing on host instead of in container: defeats the overlay.
- Container justfile re-invoking `docker run`: accidental docker-in-docker.
- Mounting container justfile read-write instead of `:ro`: container build can edit the host file.
- Escaping ceremony for recipe args: `+ARGS` preserves multi-word args through delegation without `$$`-escaping. Use it.
