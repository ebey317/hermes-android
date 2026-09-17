# AGENTS.md

This file gives AI coding agents (Claude Code, Cursor, Codex, Hermes, etc.) the
context they need to work productively in this repo. Read it before touching
anything.

## What this project is

> Install [Hermes Agent](https://github.com/NousResearch/hermes-agent) natively on Android through Termux, with a browser-based Web UI and optional Tailscale remote access.

## Repository layout

Top-level layout:

Directories:
- `apks/`
- `config/`
- `docs/`
- `scripts/`
- `snapshots/`

Key files:
- `AGENTS.md`
- `CODE_OF_CONDUCT.md`
- `CONTRIBUTING.md`
- `PRICING.md`
- `SECURITY.md`
- `install.sh`

## Hard rules for agents

- APK builds are reproducible — don't commit binary blobs outside `apks/`.
- `install.sh` is the only entry point. Don't ask users to manually invoke scripts.
- Docs in `docs/` are mirrored from `hermes-agent` — edit at the source when possible.

## Making a safe change

1. Read `README.md` first.
2. Match the project's existing style — read two adjacent files before writing yours.
3. If there is a `CLAUDE.md`, it overrides this file for Claude-specific guidance.
4. Run the test suite (`make test`, `pytest`, or repo-equivalent). If there is no test suite, say so in the PR.
5. Keep `git status` clean — no stray `.bak`, log, or debug files staged.

## Common failure modes

- Termux package versions drift; `install.sh` should pin critical versions.

## Project status

This is a public repository. I welcome issues and pull requests — see `CONTRIBUTING.md`
for guidelines and `SECURITY.md` for reporting vulnerabilities.
