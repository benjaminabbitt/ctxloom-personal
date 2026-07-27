#!/usr/bin/env bash
# Verify every bundle in this repo carries a valid publisher signature made by
# the expected key. Runnable locally (./.github/verify-signatures.sh) as well as
# in CI, because the failure this guards against is committed, not built: a
# bundle edited without re-signing looks completely fine until a CONSUMER
# advances its pin, at which point ctxloom WITHHOLDS the bundle and any profile
# inheriting from it silently degrades.
#
# Uses ssh-keygen -Y verify — the standard OpenSSH signature-verification path,
# the same one ctxloom itself validates against — rather than reimplementing
# SSHSIG parsing. -I pins the expected principal, so this catches all three
# failure modes in one call:
#
#   missing .sig        -> reported before we ever shell out
#   stale .sig          -> "incorrect signature" (content moved, signature did not)
#   wrong signing key   -> principal/key mismatch against allowed_signers
#
set -euo pipefail

IDENTITY="${SIGN_IDENTITY:-ben@abbitt.me}"
NAMESPACE="publish.v1.ctxloom.dev"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ALLOWED="$REPO_ROOT/.github/allowed_signers"
BUNDLES="$REPO_ROOT/.ctxloom/content/bundles"

[[ -f "$ALLOWED" ]] || { echo "FATAL: no allowed_signers at $ALLOWED"; exit 1; }
[[ -d "$BUNDLES"  ]] || { echo "FATAL: no bundle directory at $BUNDLES"; exit 1; }

# Flat bundles are <name>.yaml; directory bundles are <name>/bundle.yaml. Both
# are signed the same way (detached <file>.sig sibling), and BOTH must be
# checked — directory bundles were shipping unsigned precisely because they are
# easy to forget.
mapfile -t yamls < <(
  find "$BUNDLES" -maxdepth 1 -name '*.yaml' -type f
  find "$BUNDLES" -mindepth 2 -name 'bundle.yaml' -type f
)

# An empty sweep must FAIL, never pass quietly. A check that verifies nothing
# and exits 0 is indistinguishable from a check that verified everything, and
# that is the more dangerous of the two.
if (( ${#yamls[@]} == 0 )); then
  echo "FATAL: found no bundles under $BUNDLES — refusing to report success"
  exit 1
fi

fail=0
for yaml in "${yamls[@]}"; do
  rel="${yaml#"$REPO_ROOT"/}"
  sig="$yaml.sig"

  if [[ ! -f "$sig" ]]; then
    echo "UNSIGNED   $rel"
    fail=1
    continue
  fi

  if out=$(ssh-keygen -Y verify -f "$ALLOWED" -I "$IDENTITY" \
             -n "$NAMESPACE" -s "$sig" < "$yaml" 2>&1); then
    echo "ok         $rel"
  else
    echo "BAD SIG    $rel"
    echo "           $out"
    fail=1
  fi
done

# A .sig whose bundle is gone means a delete that left debris behind; it
# verifies nothing and misleads anyone auditing the directory.
while IFS= read -r sig; do
  [[ -f "${sig%.sig}" ]] || { echo "ORPHAN     ${sig#"$REPO_ROOT"/}"; fail=1; }
done < <(find "$BUNDLES" -name '*.yaml.sig' -type f)

echo
if (( fail )); then
  echo "FAILED: every bundle must be signed by $IDENTITY."
  echo "Fix with: ctxloom bundle sign <name>   (then commit the .sig)"
  exit 1
fi
echo "All ${#yamls[@]} bundle(s) signed by $IDENTITY."
