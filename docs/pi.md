# Pi configuration

Personal Pi configuration lives in `.pi/agent/`; `.pi/web-search.json` disables the web search curator. This is a cleaned snapshot from the private `pi-config` repository, not an import of its history. Former-company integrations, skills, the QA prompt, and the inactive learner profile are excluded.

## Install or migrate

Install the Pi CLI separately (see <https://pi.dev>), then run:

```bash
./install.sh --pi-only
```

The normal dotfiles installer also installs these links. `--pi-only` skips system packages, terminal configuration, and TPM. It links individual configuration files and resource directories into `~/.pi`, and the global Git ignore into `${XDG_CONFIG_HOME:-~/.config}/git/ignore`. Existing regular files/directories get timestamped backups; existing symlinks are repointed. Retired `APPEND_SYSTEM.md` and `subagents.json` links are removed only when owned by this checkout or the previous linked agent directory. Local files and unrelated links remain untouched.

Credentials, sessions, trust decisions, installed packages, and other runtime state remain local. Existing installed packages are not deleted, but only configured packages are loaded. Pi restores missing configured packages using `pnpm`; authenticate using `/login` on a new machine. MCP credentials remain machine-local.

Restart Pi after migration so previously loaded integrations are unloaded. Do not delete the previous checkout or archive its remote until the new configuration has been verified. The old repository should remain private because its history contains company-specific material.

## Personal workflow

- `AGENTS.md` owns pairing, safety, validation, and delivery rules.
- Local skills cover codebase research, workflow retrospectives, Workmux, and worktrees. The web-access package also provides the librarian skill.
- `/auto` delegates the agreed implementation through a draft PR without relaxing those rules.
- Quickfix is the guided-reading default; Harpoon remains personal bookmarks unless explicitly requested.
- `session-workflow.ts` mirrors session names into tmux and sends completion notifications; Workmux owns its status integration.
- Theme, keybindings, Zentui preferences, and general MCP connections are retained.

## Neovim bridge

Neovim loads `Tekindar666/pi.nvim`, but Pi currently uses the local companion extension at `.pi/agent/extensions/nvim-bridge/index.ts`. Do not also install the package's Pi extension: that would register the bridge twice. Consolidating the companion extension into the standalone package is separate work.

Run Pi and Neovim in the same tmux window. Save your work before restarting either application. Verify a buffer prompt can be submitted, an unsaved buffer can be read, and a requested quickfix list can be published without moving the cursor.

## Validation

```bash
bash tests/pi-install-smoke.sh
node --test tests/*.test.mjs
nvim --headless -u NONE -l tests/nvim-pi.lua
```

The Pi extension tests require the globally installed `@earendil-works/pi-coding-agent` and its dependencies. If the shell sets a different npm prefix, use the prefix containing that installation, e.g. `npm_config_prefix="$HOME/.local" node --test tests/*.test.mjs`.

Installer tests use temporary homes, exercise migration and reruns, and check that private state survives. Extension tests cover fork quoting, bridge communication, and tmux session behavior; they do not authenticate providers or exercise live external MCP services. The full dotfiles install tests also run the Pi installer checks on macOS and Arch.
