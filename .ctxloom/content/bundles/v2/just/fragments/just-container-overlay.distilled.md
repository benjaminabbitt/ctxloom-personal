---
distilled_by: claude-3-opus
---
# just-container-overlay

# just: Container Overlay Pattern

Host justfile delegates to container; inside container, different justfile mounted over host's runs actual command. Same `just build` works both contexts. No duplicate target names, no `container-build` vs `build` split.

## Setup

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

## Why it works

{{=<% %>=}}
Load-bearing: `-v {{TOP}}/justfile.container:/workspace/justfile:ro`. Bind mount obscures host `justfile` with `justfile.container` inside container. Inside: `just build` → container recipe (cargo). On host: `just build` → delegation spawning container.
<%={{ }}=%>

## Separation

- Host file: orchestrates container, never builds.
- Container file: builds, never knows about container.
- Build changes → container file only.
- Orchestration changes → host file only.

## Real-world

Angzarr uses this across coordinators (aggregate, saga, projector, process-manager, stream, log, grpc-gateway). Each has local `justfile` + `justfile.container`. Root composes via `mod`; `just aggregate build` from root and `just build` from coordinator dir or container all produce same result.

## Anti-Patterns

- `_run` running on host instead of container: defeats overlay.
- Container justfile re-invoking `docker run`: accidental docker-in-docker.
- Mounting container justfile read-write instead of `:ro`: container build edits host file.
- Arg-escaping ceremony: just's `+ARGS` preserves multi-word args through delegation without `$$`-escaping. Use it.