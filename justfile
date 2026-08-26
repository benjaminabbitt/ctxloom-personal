# ctxloom-personal — content bundle publishing helpers.
#
# Signing writes detached signatures using a key held in YOUR ssh-agent;
# ctxloom never reads or stores private key material. The key must be loaded in
# the agent and trusted under publish.v1.ctxloom.dev.
#
# THE KEY IS BAKED IN, and which one is a RULE rather than a preference:
# personal content is signed with the PERSONAL identity, while ctxloom and
# ctxloom-default are signed with the ctxloom publishing identity.
#
# Leaving it to `git config user.signingkey` is what let this drift. That lookup
# answers from whichever repository you happen to be in, so the same command
# signs as a different identity depending on where it runs — and nobody finds
# out until a consumer's trust check fails.
SIGN_KEY := "ben@abbitt.me"

# Sign every local bundle this project publishes.
sign:
    ctxloom bundle sign --all --key {{SIGN_KEY}}

# Sign one bundle, or an item ref (which resolves to its containing bundle).
#   just sign-bundle agent-ensemble
sign-bundle REF:
    ctxloom bundle sign {{REF}} --key {{SIGN_KEY}}
