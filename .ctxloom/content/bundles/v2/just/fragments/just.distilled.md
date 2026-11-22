---
source_sha256: a8af0124474cbe93f2b394a154cf6bb6223c665b3eb67875b3c319eff75bcf87
---
# just: Command Runner

- Task runner: define tasks (`just test`, `just lint`, `just build`) in a `justfile`.
- Every justfile defines at top: ``TOP := `git rev-parse --show-toplevel` ``
- All directory paths are relative to `TOP`. Non-negotiable: hard-coded relative paths or `{{justfile_directory()}}` break when a recipe runs from a subdirectory or is composed by a parent justfile.
  ```just
  TOP := `git rev-parse --show-toplevel`

  build:
      cargo build --manifest-path {{TOP}}/Cargo.toml --release

  generate:
      protoc -I {{TOP}}/proto --go_out={{TOP}}/gen {{TOP}}/proto/*.proto
  ```

## Local justfiles, composed at root

- Place a justfile beside the code it manages; compose at root with `mod`:
  ```just
  # /justfile (root)
  TOP := `git rev-parse --show-toplevel`

  mod web   "{{TOP}}/web/justfile"
  mod api   "{{TOP}}/api/justfile"
  mod infra "{{TOP}}/infra/justfile"
  ```
- Each submodule defines its own `TOP` and owns its recipes. From root: `just web build`; from `web/`: `just build`.

## Recipe shape

- Recipe used 3+ times: lift into a target.
- Top-of-file comment: purpose, prerequisites, side effects.
- Pass arguments via `+ARGS` (preserved through delegation).

## Cross-platform

- Prefer `[unix]` / `[windows]` recipe attributes over parallel platform justfiles.
- Parallel files (`justfile.nix`, `justfile.windows` via `platform_justfile` import) only when recipe shape differs.
  ```just
  [unix]
  clean:
      rm -rf {{TOP}}/target

  [windows]
  clean:
      Remove-Item -Recurse -Force {{TOP}}\target
  ```

## Anti-patterns

- Hard-coded relative paths (`./src/...`, `../proto/...`): break under composition.
- `{{justfile_directory()}}` as `TOP` stand-in: scoped to local file, not composing parent.
- Monolithic root justfile.

Container-delegated recipes (host invokes container, container runs build): see `just-container-overlay` fragment.
