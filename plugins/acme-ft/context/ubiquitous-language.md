# Acme ubiquitous language

These terms have one meaning in every Acme repository: in code, docs and conversations.

## Acme and its offer

- **Acme**: a training company. It trains development teams that already use a coding agent.
- **Context & Harness Engineering**: the Acme course. It moves a team from ad hoc agent use
  to a shared agentic layer, so the team delegates work and keeps control of the result.
- **Team**: the developers of one client who follow the course together.
- **Participant**: one developer of the team.
- **Session**: one training day. Between sessions, the team applies the course to its own work.
- **Chapter**: one part of the course program: the context, the building blocks, the practice.
- **Step**: one part of the training format: short theory, workshops in pairs or mob,
  practice between sessions.
- **Workshop**: hands-on work on the team's own repositories, not on a toy project.
- **Training case**: a branch of the training repository that adds one agent mechanism
  (`case-1-…` to `case-n-…`). Each case shows a tool and its limits.

## Agentic coding (the sector)

- **Coding agent**: an AI tool that reads, edits and runs code in a repository, such as Claude Code.
- **Context**: what the agent knows in a session: instructions, files it read, tool output.
- **Context window**: the token budget of a session. Every loaded instruction uses part of it.
- **Harness**: the tooling around the agent that shapes and checks its work: instructions,
  rules, hooks, skills, subagents, plugins, permissions, sandbox.
- **Agent instructions**: `AGENTS.md` and `CLAUDE.md`. They load in every session.
- **Rule**: an instruction file in `.claude/rules/`. It loads in every session, or only when
  the agent works on files that match its `paths`.
- **Hook**: a command that Claude Code runs at a fixed event: session start, before a tool call,
  end of a turn. It runs every time, whatever the agent decides.
- **Skill**: a procedure. Only its description is in context until the agent runs it.
- **Subagent**: an agent with its own fresh context and tools. It knows only the message it gets.
- **Plugin**: a package of skills, agents, hooks and output styles that several repositories share.
- **Delegation**: giving a task to an agent while the developer stays in control of the result.
- **Verification**: a check that the result matches the request: tests, browser review, CI.
- **Acceptance criteria**: the points of a request that a verification confirms one by one.

## Sub-domains

Each sub-domain glossary is a skill of the `acme-ft` plugin. It loads only when the work
is about that sub-domain:

- `glossary-landing-page`: the landing page and the waitlist, with their code names.
