# Repository Guidelines

## Project Structure & Module Organization
- `init.lua` boots Neovim, loading `lua/config` for options, keymaps, autocommands, and LazyVim bootstrap.
- `lua/config/` holds core behavior: `lazy.lua` (plugin loader), `options.lua`, `keymaps.lua`, `autocmds.lua`, and `neovide_config.lua`.
- `lua/plugins/` contains Lazy plugin specs; group related tweaks together (e.g., `lsp/*` for server configs, `theme.lua` for UI, `auto_save.lua` for automation).
- `lazy-lock.json` pins plugin versions; update it only when you intentionally bump plugins.
- `stylua.toml` defines formatting rules; keep Lua code aligned with it.

## Build, Test, and Development Commands
- Install dependencies (first run): `nvim --headless "+Lazy! sync" +qa` to install/update all plugins.
- Update plugins intentionally: `nvim --headless "+lua require('lazy').update()" +qa`; review `lazy-lock.json` diffs before committing.
- Quick health check: `nvim --headless "+checkhealth" +qa` to surface missing runtimes (Python, Node, etc.).
- Lint/format Lua: `stylua .` from repo root; required before commits.

## Coding Style & Naming Conventions
- Lua uses 2-space indentation, 120-column width, spaces only (`stylua.toml`).
- Prefer local-scoped variables and descriptive module names; file names in `lua/plugins/` should describe the feature (e.g., `git-blame.lua`, `blink.lua`).
- Keep plugin specs declarative: return a table, use `opts` for configuration, and avoid side effects in the module body.

## Testing Guidelines
- No automated test suite; rely on Neovim checks. Run headless `+Lazy! sync` and `+checkhealth` after plugin or LSP changes.
- Validate LSP/server tweaks by opening a relevant filetype and confirming no startup errors; document any new external dependencies in comments near the plugin spec.
- For Python debugging/LSP changes, verify the active virtualenv and run a quick buffer format/save to ensure handlers work.

## Commit & Pull Request Guidelines
- Existing history uses short, descriptive messages (often Chinese). Keep commits concise and focused on one change set; include English context when helpful.
- Before opening a PR: summarize the change, note affected modules (`lua/config/*`, `lua/plugins/*`), list manual checks run (`Lazy sync`, `checkhealth`), and mention any plugin version bumps.
- Include screenshots only when altering visuals (themes, UI plugins). Link related issues or reproduce steps if fixing a bug.
