---
name: write-pr-description
description: Write the title and description of a pull request. Use it when the user asks to open a pull request or to write or improve its description.
---

# Write a pull request description

@${CLAUDE_PLUGIN_ROOT}/shared/plain-language.md

## For a pull request

- Title: what the change does, in the imperative, under 70 characters.
- Body, in this order:
  1. what changes and why;
  2. how it was tested;
  3. what is not done or not tested;
  4. what the reviewer should look at first.
- Link the ticket.
- Do not list every file: the diff shows them.
- Write in the language the team uses on the repository host.
