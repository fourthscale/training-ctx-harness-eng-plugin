#!/usr/bin/env bash
# SessionStart hook: put the Acme ubiquitous language into Claude's context.
#
# Why a hook
#   A plugin cannot ship CLAUDE.md or rules. A SessionStart hook is how a plugin loads
#   context into every session, in every repository that enables the plugin.
#
# How it works
#   Claude Code runs this script when a session starts or resumes, and after /clear or a
#   compaction (no matcher in hooks.json = every source). On exit 0, stdout is added to
#   Claude's context.
#
# Limits
#   - Injected text is capped at 10,000 characters. Above that, Claude only gets a preview.
#   - Write facts, not orders: imperative text can be taken for a prompt injection.
#   - It loads in every session of every repository: each line costs tokens everywhere.
#
# Two levels
#   Core terms, shared by every repository: here, always loaded.
#   Sub-domain terms: one skill per sub-domain (skills/glossary-*), loaded on demand.

set -euo pipefail

cat "${CLAUDE_PLUGIN_ROOT}/context/ubiquitous-language.md"
