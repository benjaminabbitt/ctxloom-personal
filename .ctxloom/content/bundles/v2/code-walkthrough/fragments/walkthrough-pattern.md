---
tags:
  - review
  - interaction
content_hash: sha256:1e6c86fdfb147affc5321989ef9f1092d26bb4e8affd3516185e17f0f853aca3
---
# Code Walkthrough Pattern

## Purpose

An interactive pattern for reviewing code where the AI presents small, digestible chunks
and the human provides feedback, asks questions, or approves changes before proceeding.

## How It Works

1. **Present one function/method at a time**
   - Show the actual code (not summarized)
   - Keep chunks small enough to reason about (typically one function)
   - Include file path and line numbers for context

2. **Explain non-obvious aspects**
   - Describe what the code does
   - Note any dependencies or side effects
   - Highlight key design decisions

3. **Proactively identify issues**
   - Ask questions if something seems unusual or odd
   - Point out potential design concerns
   - Suggest alternatives when appropriate

4. **Wait for human input**
   - Don't proceed until the human says to continue
   - Be ready to make changes if requested
   - Implement fixes before moving to the next chunk

## Interaction Flow

```
AI: [presents function with explanation]
    [asks questions about oddities]
    "Changes, or continue?"

Human: [provides feedback / requests changes / says continue]

AI: [if changes requested: make them, show result]
    [if continue: present next function]
```

## When to Use

- Codebase onboarding and knowledge transfer
- Code review where human approval is needed per-change
- Refactoring sessions with incremental validation
- Teaching/learning scenarios

## Key Principles

- **Small chunks**: One function at a time allows focused review
- **Human control**: The human decides when to proceed
- **Immediate fixes**: Changes are made before moving on
- **Curiosity**: AI should question unusual patterns, not just explain them