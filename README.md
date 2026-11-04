# Work laptop setup

A small terminal setup for a locked-down Mac. It contains no personal details,
AI command-line tools, VPNs or credentials.

## Before you start

Check your company's policy on installing developer tools. Don't work around a
network block or a security control.

## Install

No GitHub sign-in is needed.

```bash
git clone https://github.com/princeede/mac-terminal-setup.git ~/mac-terminal-setup
cd ~/mac-terminal-setup
./install.sh
```

It asks for your name and work email only if git doesn't have them yet. If
Homebrew isn't available it stops without changing anything. To add just the
config, run `./install.sh --config-only`.

## What it changes

- Adds one line each to `~/.zshrc` and `~/.zshenv`.
- Copies files to `~/.work-setup`.
- Sets git options you haven't set. It never replaces your existing values.
- Installs Node with mise only if Node is missing.

## Cursor

If your company allows them:

1. pstack: run `/add-plugin pstack`, then `/setup-pstack`, in a Cursor chat.
2. Matt Pocock's skills: `npx skills@latest add mattpocock/skills -a cursor`
3. Rules: paste `AGENTS.md` into Cursor Settings > Rules > User Rules.

## Undo

Delete the `# Work setup` lines from `~/.zshrc` and `~/.zshenv`, then delete
`~/.work-setup`. To remove a tool, run `brew uninstall <name>` for it.
