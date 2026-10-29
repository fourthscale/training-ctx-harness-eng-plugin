---
name: write-agent-instructions
description: Create or edit AGENTS.md or CLAUDE.md, the agent instructions of a repository. Use it when the user asks to add to, clean up or restructure them.
---

# Write agent instructions

@${CLAUDE_PLUGIN_ROOT}/shared/ste.md

## For AGENTS.md and CLAUDE.md

- These files load in every session. Keep only what every task needs.
- Keep: the purpose of the repository, the stack, the commands, the language, where the rules are.
- Move out what only part of the work needs:
  - a convention for part of the code: a rule with `paths`;
  - a procedure: a skill;
  - what must always happen: a hook.
- Put the content in `AGENTS.md`, which most agents read. `CLAUDE.md` only imports it (`@AGENTS.md`).
- Read the existing rules first. Do not repeat them.
