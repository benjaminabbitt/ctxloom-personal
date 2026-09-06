---
tags:
  - just
  - tooling
  - task-runner
  - convention
  - top
  - composition
content_hash: sha256:8ccb04fc2e563156119b788b250b4b587cb002fb593557ca8b05d00f3608a182
---
# just: Command Runner

Language-agnostic task runner. Define common tasks (`just test`, `just lint`, `just build`) in a `justfile`.

## TOP: the standard repo-root variable

Every justfile in this convention defines `TOP` at the top of the file:

```just
TOP := `git rev-parse --show-toplevel`
```

{{=<% %>=}}
All directory paths in the file are expressed relative to `TOP`. Non-negotiable. A justfile that hard-codes relative paths or relies on `{{justfile_directory()}}` breaks the moment a recipe is invoked from a subdirectory or composed by a parent justfile.
<%={{ }}=%>

{{=<% %>=}}
```just
TOP := `git rev-parse --show-toplevel`

build:
    cargo build --manifest-path {{TOP}}/Cargo.toml --release

generate:
    protoc -I {{TOP}}/proto --go_out={{TOP}}/gen {{TOP}}/proto/*.proto
```
<%={{ }}=%>

## Local justfiles, composed at the root

Place a justfile next to the code it manages. Compose them at the root using `mod`:

{{=<% %>=}}
```just
# /justfile (root)
TOP := `git rev-parse --show-toplevel`

mod web   "{{TOP}}/web/justfile"
mod api   "{{TOP}}/api/justfile"
mod infra "{{TOP}}/infra/justfile"
```
<%={{ }}=%>

Each submodule defines its own `TOP` (resolved the same way) and owns its own recipes. From the root: `just web build`. From inside `web/`: `just build`. Same recipes, no duplication.

A monolithic root justfile that owns every recipe grows past readability and turns every subdirectory change into a root-file change. Don't do that.

## Recipe shape

- Recipe used 3+ times: lift it into a target.
- Top of file: short comment naming purpose, prerequisites, side effects.
- Recipe arguments via `+ARGS` (preserved through delegation).

## Cross-platform

Prefer `[unix]` / `[windows]` recipe attributes over parallel platform justfiles. Reserve parallel files (`justfile.nix`, `justfile.windows` via the `platform_justfile` import pattern) for cases where the recipe shape itself differs.

{{=<% %>=}}
```just
[unix]
clean:
    rm -rf {{TOP}}/target

[windows]
clean:
    Remove-Item -Recurse -Force {{TOP}}\target
```
<%={{ }}=%>

## Anti-Patterns

- Hard-coded relative paths (`./src/...`, `../proto/...`): break under composition.
{{=<% %>=}}
- `{{justfile_directory()}}` as a stand-in for `TOP`: scoped to the local file, not the composing parent.
<%={{ }}=%>
- A monolithic root justfile.

For container-delegated recipes (host invokes a container, container runs the build), see the `just-container-overlay` fragment.
