# Acme — team plugins

Claude Code plugin marketplace for the **Context & Harness Engineering** training.
It goes with the training repository
[`training-ctx-harness-eng`](https://github.com/fourthscale/training-ctx-harness-eng)
(branches `case-8-plugin` and later). Acme is a fictional training company.

## Plugins

`acme-ft` is the feature-team plugin: the shared context and tooling of the team's repositories.

| Component | Contents |
| --- | --- |
| `SessionStart` hook | Loads the core Acme ubiquitous language into every session |
| Skill `glossary-landing-page` | A sub-domain glossary, loaded on demand |
| Skills `write-rule`, `write-agent-instructions`, `write-docs`, `write-pr-description`, `write-ticket` | One skill per writing task, each importing the writing standard it needs |
| Output style `Acme communication` | How the agent answers in the conversation |

## Install

In a project, `.claude/settings.json` declares the marketplace and enables the plugin, so every
developer of the team gets it when they open the repository:

```json
{
  "extraKnownMarketplaces": {
    "acme": {
      "source": { "source": "github", "repo": "fourthscale/training-ctx-harness-eng-plugin" }
    }
  },
  "enabledPlugins": { "acme-ft@acme": true }
}
```

By hand, from the project folder:

```bash
claude plugin marketplace add fourthscale/training-ctx-harness-eng-plugin
claude plugin install acme-ft@acme --scope project
```

Install with `--scope project`. The default scope is `user`: it enables the plugin in every
project on your machine, so the Acme glossary would load in unrelated sessions too.

| Scope | Written to | Applies to |
| --- | --- | --- |
| `user` (default) | `~/.claude/settings.json` | All your projects |
| `project` | `.claude/settings.json`, committed | This repository, for the whole team |
| `local` | `.claude/settings.local.json`, not committed | This repository, for you only |

Installed with the wrong scope? Turn it off for all projects; the project settings keep it on here:

```bash
claude plugin disable acme-ft@acme --scope user
```

To try a local change without installing:

```bash
claude --plugin-dir plugins/acme-ft
```

## Layout

```
.claude-plugin/marketplace.json        # the marketplace: lists the plugins
plugins/acme-ft/
├── .claude-plugin/plugin.json         # plugin manifest (name, version)
├── hooks/hooks.json                   # SessionStart -> scripts/load-ubiquitous-language.sh
├── scripts/load-ubiquitous-language.sh # prints the core glossary into the context
├── context/ubiquitous-language.md     # the core glossary
├── skills/glossary-landing-page/      # a sub-domain glossary, loaded on demand
├── skills/write-rule/                 # task: a rule in .claude/rules/
├── skills/write-agent-instructions/   # task: AGENTS.md, CLAUDE.md
├── skills/write-docs/                 # task: README, docs, guides
├── skills/write-pr-description/       # task: a pull request description
├── skills/write-ticket/               # task: a Jira ticket
├── shared/ste.md                      # standard for text an agent reads (ASD-STE100)
├── shared/plain-language.md           # standard for text a person reads (ISO 24495-1)
└── output-styles/communication.md     # how the agent answers, forced when the plugin is on
```

## Why a SessionStart hook

A plugin cannot ship `CLAUDE.md` or rules: Claude Code does not load them. For context that must
be there in every session, a `SessionStart` hook prints it. For context needed only now and then,
a skill is cheaper: only its description loads until it runs.

Limits to keep in mind:

- The injected text is capped at 10,000 characters (about 2,500 tokens). Above that, Claude Code
  saves it to a file and gives Claude only a 2,000-character preview, without asking it to read
  the rest.
- It loads in every session of every repository that enables the plugin: keep it short.
- Write it as facts, not orders: imperative text can be taken for a prompt injection.
- Users get a new glossary only when the plugin updates: bump `version` in `plugin.json`.

## Two levels of glossary

| Level | Where | Loaded | For |
| --- | --- | --- | --- |
| Core | `context/ubiquitous-language.md`, printed by the `SessionStart` hook | Every session | Terms every repository uses, one line each |
| Sub-domain | `skills/glossary-<sub-domain>/SKILL.md` | When the work is about that sub-domain (only the description loads before) | Detailed terms and code names of one area |

When the core glossary grows close to the cap, move a sub-domain out into a skill. Do not split
the core text across several hooks to get around the cap: every session would pay for all of it.

A skill loads when Claude decides the work needs it, from its description. Write the description
with the words developers use for that area, so the match happens.

## Writing standards

Two standards, one per reader, kept as shared files. Task skills import the one they need.

| Skill (task) | Standard imported | Reader |
| --- | --- | --- |
| `write-rule` | `shared/ste.md` (ASD-STE100) | An agent |
| `write-agent-instructions` | `shared/ste.md` | An agent |
| `write-docs` | `shared/plain-language.md` (ISO 24495-1) | A person who looks something up |
| `write-pr-description` | `shared/plain-language.md` | A reviewer |
| `write-ticket` | `shared/plain-language.md` | The team |

The person in the conversation gets the output style `Acme communication` instead.

Why task skills and not standard skills: an agent picks a skill from the task it is asked to do.
A first design had standard skills (`writing-for-agents`…): asked to "add a rule", the
agent did not load `writing-for-agents`, even with "rules" in its description. A skill named after
the task, such as `write-rule`, matches the request itself.

Why skills and not rules: a plugin cannot ship rules. The skills have no `paths`: a test showed
that `paths` on a skill does not load its content when a matching file is read. You can also run
a skill by hand, which always works: `/acme-ft:write-rule`.

Not covered by a skill, on purpose:

- Code comments: no request looks like "write a comment", so a skill would never load.
  Put two lines in each repository's `AGENTS.md` instead.
- Skills and agents: the `skill-creator` plugin already covers them.
- Commit messages: each repository's git rule covers them.

Why an output style for the conversation: it is sent with every request, at system prompt level,
so it shapes every answer. `force-for-plugin: true` applies it as soon as the plugin is enabled.
`keep-coding-instructions: true` keeps Claude Code's coding instructions. Subagents do not get it:
they report to the main agent, which answers in this style.

One source for the plain language rules, repeated once in the output style:

- The skills import their standard with `@${CLAUDE_PLUGIN_ROOT}/shared/<standard>.md`.
  The file arrives with the skill.
  Claude Code does not document imports in skills: a test showed they work, recheck after updates.
- The output style cannot import a file (tested): it states the same rules in its own sections,
  marked in the file. When you change `shared/plain-language.md`, check the output style too.
- The output style adds agent rules that ISO 24495-1 does not cover: answer in the user's language,
  no recap, say what is not done or not verified.

## Versions

Every training case uses the latest plugin from `main`. Cases do not pin a version: a user
registers one `acme` marketplace, so a different `ref` per branch would mean updating or
reinstalling the plugin at each branch switch.

| Version | Adds |
| --- | --- |
| `0.1.0` | Ubiquitous language (hook and sub-domain skill), task skills for writing, and the communication output style. Some output style rules are adapted from [i-have-adhd](https://github.com/ayghri/i-have-adhd) (MIT) |

To release: bump `version` in `plugin.json`, commit and push `main`.

To get a new version, from the project folder, run both commands, then restart Claude Code.
The first one refreshes the catalog; the second one updates the installed plugin.

```bash
claude plugin marketplace update acme
```

```bash
claude plugin update acme-ft@acme --scope project
```

Check the marketplace and the plugin before publishing:

```bash
claude plugin validate .
```

## License

[PolyForm Noncommercial 1.0.0](LICENSE.md): free for noncommercial use, including teaching
and learning. For commercial use, contact Ludovic Raymond (ludovic.raymond@fourthscale.com).
