---
distilled_by: claude-3-opus
---
# just: Command Runner

Language-agnostic task runner. Define tasks (`just test`, `just lint`, `just build`) in a `justfile`.

## TOP: standard repo-root variable

Every justfile defines `TOP`:

```just
TOP := `git rev-parse --show-toplevel`
```

{{=<% %>=}}
All paths relative to `TOP`. Non-negotiable. Hard-coded relative paths or `{{justfile_directory()}}` break when invoked from subdirs or composed by parent justfiles.
<%={{ }}=%>

{{=<% %>=}}
```just
TOP := `git rev-parse --show-toplevel`

build:
    cargo build --manifest-path {{TOP}}/Cargo.toml --release
```
<%={{ }}=%>

## Local justfiles, composed at root

Place justfile next to code it manages. Compose via `mod`:

{{=<% %>=}}
```just
# /justfile (root)
TOP := `git rev-parse --show-toplevel`

mod web   "{{TOP}}/web/justfile"
mod api   "{{TOP}}/api/justfile"
```
<%={{ }}=%>

Each submodule defines own `TOP`, owns own recipes. Root: `just web build`. Inside `web/`: `just build`. DO NOT use monolithic root justfile.

## Recipe shape

- Used 3+ times: lift to target.
- Top of file: short comment (purpose, prerequisites, side effects).
- Args via `+ARGS` (preserved through delegation).

## Cross-platform

Prefer `[unix]` / `[windows]` attributes over parallel platform justfiles. Reserve parallel files (`platform_justfile` import) for differing recipe shapes.

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

- Hard-coded relative paths (`./src/...`): break under composition.
{{=<% %>=}}
- `{{justfile_directory()}}` as `TOP` stand-in: scoped to local file, not composing parent.
<%={{ }}=%>
- Monolithic root justfile.

For container-delegated recipes, see `just-container-overlay` fragment.