---
tags:
  - event-sourcing
  - naming
premise: >-
  Naming, adding or renaming a command, fact or event in an event-sourced or
  CQRS system: a proto message, an aggregate's handler, a domain event, or a
  refusal raised by a decision.
---
# Requests are imperative; events are declarative

A message either ASKS the domain to do something or STATES what the domain
recorded. Its name says which, by grammatical mood alone.

## Commands and facts: imperative

A command (a request a decision may refuse) and a fact (an observation from
outside handed to an aggregate to record) are named as an instruction, verb
first: `CloseSession`, `MintSession`, `ResumeSession`, `EnqueueRun`,
`RecordIncarnationEnded`. A fact is still a request to RECORD: the aggregate decides whether
it applies (a duplicate, a stream that does not exist), so it is imperative
too, usually `Record<Something>`.

## Events: declarative

An event is what the aggregate decided and wrote; it cannot be refused,
because it already happened. It is named as a completed statement, subject
then past participle: `SessionClosed`, `RunEnqueued`, `IncarnationOwed`,
`IncarnationEnded`, `RunnerStarted`. Never an instruction (`CloseSession` as an event
reads as a request nobody answered) and never a gerund or state (`Closing`,
`Closed` alone: an event names its subject).

## The pair reads as request and record

Where a command or fact yields one event, the two read as a request and its
record: `CloseSession` → `SessionClosed`, `RecordIncarnationEnded` →
`IncarnationEnded`. A command may legitimately record an event of another
name when what happened is different from what was asked (`ResumeSession`
records `IncarnationOwed`: the resume is owed a new incarnation); the event
still states what happened, never what was asked.

## Refusals and read models

A refusal names the condition that forbids the request, as a state
(`SessionRunning`, `NoNativeSession`), not as a verb. A projection or read
model names what it holds (`SessionIndex`, `PendingLaunches`), never an action.

## Why the mood matters

The mood is the only marker that survives into a log, a stream listing, or a
proto diff without its handler beside it. A reader of a stream sees only
events and must trust each as settled; a reader of an inbox sees only
requests and must expect some to be refused. A name in the wrong mood makes
one look like the other.
