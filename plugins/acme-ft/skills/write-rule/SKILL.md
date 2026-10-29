---
name: write-rule
description: Create or edit a Claude Code rule in .claude/rules/. Use it when the user asks to add, change, split or clean up a rule.
---

# Write a rule

@${CLAUDE_PLUGIN_ROOT}/shared/ste.md

## For a rule

- One topic per rule file. Name the file after the topic, in kebab-case.
- Read the existing rules and `AGENTS.md` first. Do not repeat what they already say.
- Decide when the rule loads:
  - No `paths`: it loads in every session. Use it only for what applies everywhere.
  - `paths`: it loads when the agent reads or edits a matching file.
    List every file the rule is about, not only the main folder.
- Keep the rule short: every line costs tokens each time it loads.
- A procedure is not a rule: make it a skill. What must always happen is not a rule: make it a hook.
- Write rules in English.
