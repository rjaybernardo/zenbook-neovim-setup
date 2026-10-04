# Neovim config

A Neovim **0.12** setup that works like VS Code: VS Code shortcuts on top of normal Vim keys. It uses built-in features wherever they exist (`vim.pack`, LSP, completion, snippets, commenting) and adds a small set of plugins for the rest.

**Leader key:** `Space`. Press it and wait, and which-key shows what comes next.

**In the tables:** ✅ means same as VS Code. ≈ means it does the same job with a different key (the VS Code key is shown). — means Vim-only.

---

## What changed (October 2026)

These behave differently from the old setup. Everything else you knew still works the same way.

| Before | Now |
|---|---|
| `Ctrl+B` scrolled up a page | Toggles the file sidebar (`Ctrl+U` still scrolls up half a page) |
| `Ctrl+S` in insert mode showed parameter hints | Saves; parameter hints are on `Ctrl+Shift+Space` |
| `gL` / `gC` commented code | Built-in `gcc` (line) / `gc` (motion or selection); `Ctrl+/` unchanged |
| `gT` was taken by mini.comment | `gT` goes to the previous Vim tab page again |
| `Ctrl+Space` in tmux entered copy mode | `Ctrl+B` then `Ctrl+Space` |
| Long lines wrapped | No wrapping; `Alt+Z` toggles it |
| New lines indented with tabs | 2 spaces (projects with `.editorconfig` use their own setting) |
| Code files also suggested buffer words | Code files suggest language server results + snippets; plain files suggest buffer words |
| nvim-cmp popup (`Ctrl+B` / `Ctrl+F` scrolled docs) | Built-in completion menu; docs show in a side popup |

**New, nothing to unlearn:**
- VS Code shortcuts (tables below)
- `` Ctrl+` `` terminal panel
- Breadcrumbs at the top of each window
- Sticky scroll
- `Space uu` undo tree
- `Space uh` inlay hints
- Files reload when changed outside Neovim
- Files reopen at your last cursor position

---

## Terminal setup (one-time)

Neovim only receives shortcuts like `Ctrl+Shift+P`, `Ctrl+.`, `Ctrl+Enter` and `` Ctrl+` `` if the terminal passes them through.

**tmux:** the tmux config is in this repo at `tmux/tmux.conf`. It already turns on `extended-keys`, which passes those shortcuts through. Link it into place once, then reload tmux:

```sh
mkdir -p ~/.config/tmux
ln -sf ~/.config/nvim/tmux/tmux.conf ~/.config/tmux/tmux.conf
tmux source-file ~/.config/tmux/tmux.conf
```

It also sets up:
- **Seamless navigation:** `Ctrl+H/J/K/L` moves between tmux panes and Neovim splits.
- **Copy mode:** `Ctrl+B` then `Ctrl+Space`. It's on the prefix so that `Ctrl+Space` reaches Neovim for completion. In copy mode, `Ctrl+Space` starts a selection, and `y` or `Alt+W` copies to the system clipboard.
- **Other:** mouse support and vi keys.

**Ghostty:** the Ghostty config is in this repo at `ghostty/config`. Link it into place once:

```sh
mkdir -p ~/.config/ghostty
ln -sf ~/.config/nvim/ghostty/config ~/.config/ghostty/config
```

By default Ghostty takes these shortcuts for itself, so Neovim never sees them:

| Key | Ghostty default | Neovim (VS Code layer) |
|---|---|---|
| `Ctrl+Shift+P` | Ghostty command palette | Command palette |
| `Ctrl+Shift+F` | Search scrollback | Search in files |
| `Ctrl+Shift+E` / `Ctrl+Shift+O` | New split down / right | Focus explorer / Go to symbol |
| `Ctrl+Shift+I` | Inspector | Format document |
| `Ctrl+Tab` / `Ctrl+Shift+Tab` | Next / previous Ghostty tab | Next / previous tab |
| `Ctrl+Enter` / `Ctrl+Shift+Enter` | Fullscreen / zoom split | Insert line below / above |
| `Ctrl+,` | Open Ghostty config | Open Neovim config |

To give a key to Neovim, add an `unbind` line for it to `ghostty/config`, for example:

```
keybind = ctrl+shift+p=unbind
```

Every VS Code shortcut also has a leader-key or Vim equivalent below, so nothing is lost if a combo doesn't come through.

**Starship (prompt):** the prompt config is in this repo at `starship/starship.toml`. It's a minimal Pure-style prompt: path, git branch and status, command duration, and a `❯` that turns red after an error and becomes a green `❮` in zsh's vi normal mode. Link it into place once:

```sh
ln -sf ~/.config/nvim/starship/starship.toml ~/.config/starship.toml
```

**fastfetch:** the system info shown when a terminal opens comes from `fastfetch/config.jsonc` in this repo. It has no logo and shows title, OS, kernel, CPU, GPU, memory, disk, uptime and window manager. Link it into place once:

```sh
mkdir -p ~/.config/fastfetch
ln -sf ~/.config/nvim/fastfetch/config.jsonc ~/.config/fastfetch/config.jsonc
```

**niri (window manager):** the niri config is in this repo at `niri/` (`config.kdl` plus the files it includes from `cfg/`). The whole folder is linked, so the relative includes keep working. Link it into place once:

```sh
ln -sfn ~/.config/nvim/niri ~/.config/niri
```

Check it with `niri validate` after editing.

---

## Files & navigation

| Keys | Action | VS Code? |
|---|---|---|
| `Ctrl+P` | Quick open file | ✅ |
| `F1` | Command palette | ✅ |
| `Ctrl+Shift+P` | Command palette (niri uses this key for screenshots, so use `F1`) | ✅ |
| `Ctrl+Shift+F` | Search in files (live grep) | ✅ |
| `Ctrl+Shift+O` | Go to symbol in file | ✅ |
| `Ctrl+Shift+M` | Problems (all diagnostics) | ✅ |
| `Ctrl+,` | Settings (opens this config) | ✅ |
| `Ctrl+B` | Toggle sidebar (Neo-tree) | ✅ |
| `Ctrl+Shift+E` | Focus explorer, reveal current file | ✅ |
| `Ctrl+Shift+G` | Source control (LazyGit) | ✅ |
| `Ctrl+Tab` / `Ctrl+Shift+Tab` | Next / previous tab | ✅ |
| `Ctrl+S` | Save (formats on save) | ✅ |
| `H` / `L` | Previous / next tab | — |
| `Space x` | Close current tab | ≈ `Ctrl+W` |
| `Space co` | Close all other tabs | ≈ "Close Others" |
| `Space e` | Toggle file explorer | ≈ `Ctrl+B` |
| `-` | Open parent folder in Oil (edit the listing like text to rename, move or delete files) | — |
| `Space ff` | Find files | ≈ `Ctrl+P` |
| `Space fg` | Live grep | ≈ `Ctrl+Shift+F` |
| `Space fb` | Find open buffers | — |
| `Space fh` | Search help | — |

**Inside Neo-tree:** `l` opens, `h` collapses, `a` adds a file or folder, `d` deletes, `r` renames, `?` lists every key.

## Editing

| Keys | Action | VS Code? |
|---|---|---|
| `Ctrl+/` | Toggle comment (line or selection) | ✅ |
| `Alt+↑` / `Alt+↓` | Move line or selection | ✅ |
| `Shift+Alt+↑` / `Shift+Alt+↓` | Copy line or selection up / down | ✅ |
| `Ctrl+Shift+K` | Delete line | ✅ |
| `Ctrl+Enter` / `Ctrl+Shift+Enter` | Insert line below / above | ✅ |
| `Alt+Z` | Toggle word wrap | ✅ |
| `Shift+Alt+F` / `Ctrl+Shift+I` | Format document | ✅ |
| `Space =` | Format document | ≈ `Shift+Alt+F` |
| `Ctrl+N` | Multi-cursor: select word, again for next match | ≈ `Ctrl+D` |
| `Ctrl+Alt+N` | Multi-cursor: select all matches | ≈ `Ctrl+Shift+L` |
| `Ctrl+↑` / `Ctrl+↓` | Add cursor above / below | ≈ `Ctrl+Shift+↑/↓` |
| `v` then `an` / `in` | Expand / shrink selection by syntax node | ≈ `Shift+Alt+→/←` |
| `gc{motion}` / `gcc` | Comment with a motion / current line (built in) | — |
| `<` / `>` (visual) | Indent, keeping the selection | ≈ `Ctrl+[` / `Ctrl+]` |
| `n` / `N` | Next / previous search match, centered | — |
| `Space ch` | Clear search highlight | — |
| `Space uu` | Undo tree (built in) | ≈ Timeline |

HTML/JSX tags close and rename automatically. Brackets and quotes auto-pair.

## Code intelligence (LSP)

| Keys | Action | VS Code? |
|---|---|---|
| `F12` | Go to definition | ✅ |
| `Ctrl+F12` | Go to implementation | ✅ |
| `Shift+F12` | Find all references | ✅ |
| `F2` | Rename symbol | ✅ |
| `Ctrl+.` | Quick fix / code action | ✅ |
| `F8` / `Shift+F8` | Next / previous problem | ✅ |
| `Ctrl+Shift+Space` (insert) | Parameter hints | ✅ |
| `K` | Hover docs | ≈ `Ctrl+K Ctrl+I` |
| `grn` | Rename (built in) | ≈ `F2` |
| `gra` | Code action (built in) | ≈ `Ctrl+.` |
| `grr` | References (built in) | ≈ `Shift+F12` |
| `gri` | Implementation (built in) | ≈ `Ctrl+F12` |
| `grt` | Type definition (built in) | — |
| `gO` | Document symbols (built in) | ≈ `Ctrl+Shift+O` |
| `grx` | Run code lens (built in) | — |
| `gl` | Show diagnostic under cursor | ≈ hover on squiggle |
| `[d` / `]d` | Previous / next diagnostic (built in) | ≈ `Shift+F8` / `F8` |
| `Space q` | Toggle quickfix list of diagnostics | ≈ `Ctrl+Shift+M` |

The top of each window shows breadcrumbs (`file › class › function`), like VS Code. Sticky scroll keeps the enclosing function header visible. Tailwind and CSS colors are highlighted inline.

## Completion & snippets

Completion uses Neovim's built-in menu and pops up as you type. In buffers without a language server it suggests words from open files.

| Keys | Action | VS Code? |
|---|---|---|
| `Ctrl+Space` | Trigger suggestions | ✅ |
| `Enter` | Accept (first item if none selected) | ✅ |
| `Tab` / `Shift+Tab` | Next / previous snippet field, or next / previous item | ≈ |
| `Ctrl+J` / `Ctrl+K` | Next / previous item | ≈ `↓` / `↑` |
| `Ctrl+E` | Close the menu | ≈ `Esc` |
| `Ctrl+X Ctrl+F` | Complete a file path | — |

**JS / TS / React snippets** (in `lua/snippets/javascript.lua`):

| Trigger | Expands to |
|---|---|
| `af` | `(args) => { }` |
| `caf` | `const fn = (args) => { };` |
| `afc` | async arrow function with try/catch |
| `ef` / `edf` | `export function` / `export default function` |
| `eaf` | `export const fn = () => { };` |
| `ec` | `export const name = value;` |
| `clg` / `cle` | `console.log("x", x)` / `console.error("x", x)` |
| `us` / `ue` / `ur` | `useState` / `useEffect` / `useRef` |
| `rafce` | React arrow function component with default export |

To add snippets for another language, create `lua/snippets/<lang>.lua` and register it in `lua/snippets/init.lua`.

## Terminal

| Keys | Action | VS Code? |
|---|---|---|
| `` Ctrl+` `` | Toggle terminal panel | ✅ |
| `Space tt` | Toggle terminal panel | ≈ `` Ctrl+` `` |
| `Space th` / `Space tv` | New terminal in a horizontal / vertical split | ≈ "Split Terminal" |
| `Esc Esc` | Leave terminal mode (scroll, copy) | — |
| `Space lg` | LazyGit | ≈ `Ctrl+Shift+G` |

## Windows & splits

| Keys | Action | VS Code? |
|---|---|---|
| `Ctrl+H/J/K/L` | Move between splits and tmux panes | — |
| `Space w h/j/k/l` | Move between splits | — |
| `Ctrl+Shift+Arrows` | Resize split | — |

## Toggles & misc

| Keys | Action | VS Code? |
|---|---|---|
| `Space uf` | Toggle format on save | ≈ `editor.formatOnSave` |
| `Space ud` | Toggle diagnostics | — |
| `Space uh` | Toggle inlay hints | ≈ `editor.inlayHints` |
| `Space ls` / `Space lx` | Start / stop Live Server (port 8080) | ≈ Live Server extension |
| `Space k` | Show all keymaps (which-key) | ≈ `Ctrl+K Ctrl+S` |
| `Space ?` | List normal-mode mappings | — |
| `ZR` | Restart Neovim and keep the session (0.12) | ≈ "Reload Window" |

---

## Shell (zsh) & tmux

Your zsh is in **vi mode**: `Esc` switches the prompt to Vim normal mode, and `i` / `a` go back to typing.

| Keys | Action |
|---|---|
| `↑` / `↓` | Search history for commands starting with what you've typed |
| `Ctrl+←` / `Ctrl+→` | Jump a word left / right |
| `Home` / `End` / `Delete` | Start of line / end of line / delete character |
| `Tab` | Completion menu (move with arrow keys; matching ignores case) |
| `→` at end of line | Accept the grey autosuggestion |
| ` cmd` (leading space) | Run without saving to history |
| `z <part of dir>` | Jump to a frequently used folder (zoxide) |
| `v` | `nvim` |
| `gs` / `ga` / `gc` / `gp` / `gl` | git status / add / commit / push / log graph |

Commands turn green or red as you type, depending on whether they exist (syntax highlighting).

| tmux keys | Action |
|---|---|
| `Ctrl+H/J/K/L` | Move between panes and Neovim splits |
| `Ctrl+B` then `Ctrl+Space` | Copy mode |
| `Ctrl+Space` (in copy mode) | Start selection |
| `y` / `Alt+W` (in copy mode) | Copy to system clipboard |

---

## Desktop (niri)

`Mod` is the Super / Windows key. Press `Mod+Shift+Esc` to see every binding.

| Keys | Action |
|---|---|
| `Mod+Space` | App launcher |
| `Mod+T` | Terminal (Ghostty) |
| `Mod+G` / `Mod+E` / `Mod+D` | Chrome / Nautilus / Dolphin |
| `Mod+N` / `Mod+F` / `Mod+K` / `Mod+B` | Obsidian / FreeCAD / Kdenlive / Blanket |
| `Mod+Q` | Close window |
| `Mod+←` / `Mod+→` | Focus column left / right |
| `Mod+↑` / `Mod+↓` | Workspace up / down |
| `Mod+Ctrl+←/→` (or `H`/`L`) | Move column left / right |
| `Mod+Shift+↑/↓` | Move window to workspace up / down |
| `Mod+1`…`9` / `Mod+Ctrl+1`…`9` | Go to workspace / move column there |
| `Mod+Tab` | Previous workspace |
| `Mod+R` / `Mod+Shift+R` | Cycle column width presets |
| `Mod+-` / `Mod+=` | Column width −10% / +10% |
| `Mod+X` / `Mod+Shift+F` / `Mod+Z` | Maximize column / fullscreen / maximize to edges |
| `Mod+W` | Tabbed column |
| `Mod+C` | Center column |
| `Mod+O` | Overview |
| `Mod+S` / `Mod+Shift+S` | Noctalia control center / settings |
| `Mod+Alt+L` / `Mod+Shift+Q` | Lock / session menu |
| `Ctrl+Shift+P` or `Ctrl+Shift+1` | Screenshot area |
| `Ctrl+Shift+2` / `Ctrl+Shift+3` | Screenshot screen / window |
| `Mod+Esc` | Emergency: un-inhibit shortcuts |

---

## Useful commands

| Command | What it does |
|---|---|
| `:lsp` | Manage language servers (0.12): status, restart, stop |
| `:Mason` | Install or update LSP servers and tools |
| `:checkhealth` | Diagnose problems (`:checkhealth vim.lsp` for LSP) |
| `:ConformInfo` | Show which formatter runs for the current file |
| `:lua vim.pack.update()` | Update plugins (shows a review buffer first) |
| `:lua vim.pack.del({ "name" })` | Delete a plugin from disk after removing it from `pack.lua` |
| `:TSUpdate` | Update treesitter parsers |
| `:packadd nvim.undotree` then `:Undotree` | Visual undo history (or just `Space uu`) |
| `:packadd nvim.difftool` then `:DiffTool a b` | Compare two files or directories (0.12) |
| `:restart` | Restart Neovim |
| `:Telescope` | List every picker (keymaps, git, highlights, …) |

---

## Layout

```
init.lua                  entry point
lua/config/
  options.lua             editor options, plugin globals, filetypes
  pack.lua                plugin list (vim.pack)
  keymaps.lua             Vim-style keymaps
  vscode.lua              VS Code keymaps + terminal panel
  autocmds.lua            yank highlight, auto-reload, restore cursor, …
  winbar.lua              breadcrumbs
lua/plugins/              one file per plugin area (lsp, completion, git, …)
lua/snippets/             snippet definitions + the in-process LSP that serves them
tmux/tmux.conf            tmux config (symlinked to ~/.config/tmux/tmux.conf)
ghostty/config            Ghostty config (symlinked to ~/.config/ghostty/config)
starship/starship.toml    Starship prompt (symlinked to ~/.config/starship.toml)
fastfetch/config.jsonc    fastfetch layout (symlinked to ~/.config/fastfetch/config.jsonc)
niri/                     niri config (folder symlinked to ~/.config/niri)
```

To use pure Vim keys again, remove `require("config.vscode")` from `init.lua`.

**Built in, no plugin needed:** plugin manager, LSP setup, completion, snippets, commenting, syntax-aware selection, undo tree, inline color previews.

**Plugins:** catppuccin, oil, neo-tree, telescope, gitsigns, lazygit, conform, nvim-treesitter (+ context, autotag), mason, nvim-lspconfig, mini (icons, pairs, statusline, tabline, indentscope), navic, which-key, vim-visual-multi, vim-tmux-navigator, live-server.
