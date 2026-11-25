---
name: licensing-rule
description: The owner's licensing rule for angzarr and everything built on it. Use whenever licences or licensing come up in any form: choosing or changing the licence of a repo, crate, SDK, CLI or application; writing or editing a LICENSE file, a README licence section, a Cargo.toml `license` field or per-crate LICENSE-APACHE/LICENSE-BSD files; AGPL, GPL, Apache, BSD, MIT, dual licensing, commercial licensing, a licence exception or an additional permission; the "managed service loophole"; whether linking one component into another changes its licence; consolidating or splitting repositories; or truncating git history because of licence history. Also use before publishing a new repository or tagging a release of any angzarr, ctxloom or Cherenkov component.
---

# Licensing rule (owner's, recorded 2026-11-20)

Not legal advice, and the owner's words rule over this summary. Items 4 and 5 and the distributed-runtime set were signed off on
2026-11-20; the licence files themselves are not yet written.

## The rule

1. **CLI applications that assist programmers, and general applications, are
   Apache-2.0 or BSD-3-Clause.** That is ctxloom, Cherenkov, taskloom, the
   angzarr CLI and the like.
2. **The angzarr distributed (hosted) runtime stays AGPL-3.0.** The aim is to
   close the managed-service loophole: anyone who modifies angzarr and serves
   people with it must share the changes, and all modified code should be
   available for reintegration. Unmodified commercial use is acceptable.
   A commercial licence may be offered, potentially, but only for the
   distributed/hosted version, and a paid exception for people who want to keep
   modifications private is acceptable. The owner does not care much about
   selling licences. BUSL-to-AGPL conversion and FSL were considered and
   demoted.
3. **Client-linked code is permissive (BSD-3-Clause / Apache-2.0):** the
   `.proto` files, `angzarr-proto`, the six SDKs (Rust, Python, Go, Java, C#,
   C++), `angzarr-router`, and the codegen CLI and proc-macros. Owner's words:
   "the angzarr distributed runtimes are agpl, the client linked code is
   BSD-3/Apache2."
4. **Shared runtime code gets a runtime exception (signed off 2026-11-20).** Because `angzarr-embedded` shares `angzarr-ports` with the
   distributed runtime, the proposal is AGPL plus a Classpath-style exception
   for everything that can end up in a user's process, so an application that
   links embedded is freed. Core stays plain AGPL. The owner said this "may be
   viable in other places"; that is not sign-off on a crate-by-crate table.
5. **A narrow AGPL section 7 additional permission for programs that only use
   the published gRPC API (signed off 2026-11-20).** Its purpose is to remove the FSF's
   "complex data structures" ambiguity about whether a program exchanging rich
   data with an AGPL one becomes a combined work.
6. **Licences are per crate.** One workspace may carry several licences, with a
   licence file beside each crate's `Cargo.toml` and a README table of which
   crate is under which. Do not force one licence on a merged repository.

## How to apply it

- **The licence boundary follows the linking boundary.** What an application
  links into its own process must be permissive (or covered by the runtime
  exception, once signed off), or the application inherits AGPL obligations.
  Today ctxloom, taskloom, Cherenkov and the angzarr CLI link `angzarr-embedded`,
  `-ports`, `-diagnostic`, `-presentation`, `-yaml`, `-proto`, `-build`, the
  macros and more. Check item 4 before relicensing anything those depend on.
- **Applications built on AGPL code inherit it.** `ctxloom-lib` is AGPL-3.0 and
  is linked by ctxloom, taskloom and Cherenkov; those can only become
  Apache/BSD once everything they link is permissive. Cherenkov's own README
  says AGPL-3.0.
- **The service side is what AGPL protects** (signed-off set): angzarr-coordinator,
  -coordinator-base, -coordinator-grpc, -reads, -store-sqlite, store-jsonl.
  Everything else is runtime-exception or permissive.
- **The owner is the copyright holder** and may relicense or dual-license their
  own code; contributors' rights need checking if outside contributions exist.
- Never leave a README, LICENSE file and Cargo `license` fields disagreeing.

## State when this was written (verify, it will drift)

- angzarr core: root LICENSE and README say AGPL-3.0; the README then lists
  sixteen shared crates as dual Apache-2.0 / BSD-3; every crate in core, router,
  embedded, build and platform declares `Apache-2.0 OR BSD-3-Clause`. So no
  crate in the Rust workspace is actually AGPL.
- `ctxloom-lib`: AGPL-3.0-only (or commercial). Cherenkov: AGPL-3.0-only. The
  angzarr CLI: AGPL-3.0-only with a generated-output exception.
- The five Rust repos (core, router, embedded, build, platform) are being merged
  into one workspace repository with per-crate licence files; the old repos are
  renamed and archived.

## Order of work when licences change (owner, 2026-11-20)

1. Sort the licences first: decide per crate and per repo, write the licence
   files and README tables, change the `license` fields.
2. Then truncate the old git repositories on purpose, so the history that
   carries the incorrect licence no longer sits in them. This is a force-push or
   a fresh repo, so confirm the exact list of repositories with the owner before
   doing it, and keep a mirror backup first (`git clone --mirror`).
3. Be accurate about what truncation does: it removes the old history from the
   repository, but copies already published or cloned under the earlier licence
   keep the rights that licence granted them. Do not describe truncation as
   revoking a licence.
