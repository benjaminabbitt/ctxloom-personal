---
distilled_by: claude-haiku-4-5-20251001
---
# Claims against code

Docs are falsifiable claims: commands, flags, keys, paths, defaults, behaviors. **Read the implementation, not the doc/commit msg/function name.** Mark guesses; unmarked guesses look like fact to future readers.

## Failure modes (ranked by damage)

**1. Silently-ignored key:** Config key renamed/retired, decoder not strict. Confirm struct field exists *and* what happens to unknown keys.

**2. Promise discarded:** Warning, validation, fallback computed then thrown away. Grep for the *call site*, not definition.

**3. Feature behind build tag:** Capability in source but compiled out of user binary. Check the default install path.

**4. Wrong argument kind:** Bundle name to fragment-expecting flag, local name to remote-only lookup. Run the example.

**5. Omitted step:** Flow works, produces nothing. Walk the flow as a stranger with empty machine — find the authorization step (review, trust, hook install).

**6. Stale absolute:** "Automatically", "always", "never", "isolated", "verified", "only". Each needs specific code; most are conditional.

## Security claims

Hold higher bar. **Never overclaim:** "sandboxed", "verified", "signed" must fail *closed*, not warn. Check escape hatches: missing checksum, absent key, tool not installed.

**Never underclaim:** Describing crypto guarantee as weaker teaches readers to distrust protective mechanisms.

## Generated pages

- Never hand-edit; next regeneration reverts you.
- Authoritative for surface only. If schema drifted from struct, fix the source, not prose.

## Aspirational tense

Never present-tense unshipped features. "Will" doesn't fix it — skimming readers see it as shipped.