---
distilled_by: claude-3-opus
---
# Code Walkthrough Pattern

## Purpose
Interactive review: AI presents small chunks, human approves/requests changes before proceeding.

## Flow

1. **Present one function at a time**
   - Show actual code w/ file path + line numbers
   - Keep chunks small (one function)

2. **Explain non-obvious aspects**
   - What it does, dependencies, side effects
   - Key design decisions

3. **Identify issues proactively**
   - Question unusual/odd patterns (see: questioning-patterns)
   - Note design concerns, suggest alternatives

4. **Wait for human input**
   - Don't proceed until human says continue
   - Make changes before moving to next chunk

## Interaction
```
AI: [function + explanation + questions]
    "Changes, or continue?"
H:  [feedback / changes / continue]
AI: [apply changes if requested, then next function]
```

## When to Use
- Codebase onboarding
- Code review requiring per-change approval
- Incremental refactoring
- Teaching/learning

## Principles
- Small chunks → focused review
- Human controls pace
- Immediate fixes before proceeding
- Curiosity over passive explanation (see: questioning-patterns)