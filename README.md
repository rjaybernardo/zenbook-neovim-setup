# Neovim config

A Neovim **0.12** setup that works like VS Code: VS Code shortcuts on top of normal Vim keys. It uses built-in features wherever they exist (`vim.pack`, LSP, completion, snippets, commenting) and adds a small set of plugins for the rest.

**Leader key:** `Space`. Press it and wait, and which-key shows what comes next.

**In the tables:** ✅ means same as VS Code. ≈ means it does the same job with a different key (the VS Code key is shown). — means Vim-only.

---

## Terminal setup (one-time)

Neovim only receives shortcuts like `Ctrl+Shift+P`, `Ctrl+.`, `Ctrl+Enter` and `` Ctrl+` `` if the terminal passes them through.

**tmux:** add this to `~/.config/tmux/tmux.conf`, then restart tmux:

```tmux
set -s extended-keys on
set -as terminal-features 'xterm-ghostty:extkeys'
```

**Ghostty:** Ghostty uses several `Ctrl+Shift` combos for its own features (splits, its command palette, the inspector). To let one through to Neovim, unbind it in Ghostty's config, for example:

```
keybind = ctrl+shift+p=unbind
keybind = ctrl+shift+e=unbind
```

Every VS Code shortcut also has a leader-key or Vim equivalent below, so nothing is lost if a combo doesn't come through.

---

## Files & navigation

| Keys | Action | VS Code? |
|---|---|---|
| `Ctrl+P` | Quick open file | ✅ |
| `Ctrl+Shift+P` / `F1` | Command palette | ✅ |
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
```

To use pure Vim keys again, remove `require("config.vscode")` from `init.lua`.

**Built in, no plugin needed:** plugin manager, LSP setup, completion, snippets, commenting, syntax-aware selection, undo tree, inline color previews.

**Plugins:** catppuccin, oil, neo-tree, telescope, gitsigns, lazygit, conform, nvim-treesitter (+ context, autotag), mason, nvim-lspconfig, mini (icons, pairs, statusline, tabline, indentscope), navic, which-key, vim-visual-multi, vim-tmux-navigator, live-server.
