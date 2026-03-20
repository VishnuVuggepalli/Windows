# Windows Dotfiles

Personal Windows configuration files — PowerShell profile, Claude Code settings, and Neovim config.

## Structure

```
Windows/
├── Microsoft.PowerShell_profile.ps1   # PowerShell profile
├── claude/
│   ├── settings.json                  # Claude Code global settings
│   └── settings.local.json            # Claude Code local/project overrides
└── nvim/
    ├── init.lua                       # Neovim entry point
    ├── lazy-lock.json                 # Plugin lockfile
    ├── lsp/                           # LSP server configs
    ├── lua/                           # Lua modules
    │   ├── plugins/                   # Plugin configs (lazy.nvim)
    │   │   └── heirline/              # Statusline components
    │   └── lsp/                       # LSP setup
    ├── queries/                       # Treesitter queries
    └── viml/                          # Vimscript (mappings, commands)
```

---

## PowerShell Profile

**Location:** `%USERPROFILE%\Documents\PowerShell\Microsoft.PowerShell_profile.ps1`

Uses [oh-my-posh](https://ohmyposh.dev/) for prompt theming.

### Navigation

| Command | Description |
|---------|-------------|
| `sys32` | `cd C:\Windows\System32` |
| `desk`  | `cd C:\Users\vishn\Desktop` |
| `home`  | `cd C:\Users\vishn` |

### DNS Management

| Command | Description |
|---------|-------------|
| `Set-WifiDns [-DNS '1.1.1.1','1.0.0.1'] [-Append]` | Set Wi-Fi DNS servers |
| `Get-WifiDns` | Show current DNS servers |
| `Reset-WifiDns` | Reset DNS to automatic (DHCP) |
| `flushdns` | Flush DNS resolver cache |

### Search Domain

| Command | Description |
|---------|-------------|
| `Set-SearchDomain -Suffixes 'corp.local','dev.local' [-Append]` | Set DNS search suffixes |
| `Get-SearchDomain` | View current search suffixes |
| `Reset-SearchDomain` | Clear all search suffixes |

### Hosts File

| Command | Description |
|---------|-------------|
| `hosts` | Open hosts file in Notepad (elevated) |
| `Add-HostEntry -IP '127.0.0.1' -Hostname 'myapp.local'` | Add a hosts entry (UAC-aware) |
| `Remove-HostEntry -Hostname 'myapp.local'` | Remove a hosts entry (UAC-aware) |

### Network

| Command | Description |
|---------|-------------|
| `adapters` | List all network adapters with status and speed |
| `nmap [args]` | Run nmap (expects install at `C:\Program Files (x86)\Nmap\`) |

### Help

Run `shortcuts` to print a full reference of all commands.

### Installation

```powershell
# Copy to PowerShell profile location
Copy-Item .\Microsoft.PowerShell_profile.ps1 $PROFILE
```

---

## Claude Code Settings

**Location:** `%USERPROFILE%\.claude\`

### settings.json

Global Claude Code configuration:

- **Model:** Sonnet 4.6
- **Env vars:** `MAX_THINKING_TOKENS=10000`, `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE=50`, `ECC_HOOK_PROFILE=standard`
- **Hooks:** Pre/PostToolUse, SessionStart/End, Stop — runs quality gates, formatters, type checks, cost tracking, and continuous learning observers
- **Permissions:** Allowed tools and additional readable directories

### settings.local.json

Project-specific permission overrides (per-machine allowed Bash commands and WebFetch domains).

### Installation

```powershell
# Copy settings (do NOT copy .credentials.json)
Copy-Item .\claude\settings.json $HOME\.claude\settings.json
Copy-Item .\claude\settings.local.json $HOME\.claude\settings.local.json
```

---

## Neovim Config

**Location:** `%LOCALAPPDATA%\nvim\`

Built on [lazy.nvim](https://github.com/folke/lazy.nvim) with LSP, DAP, Treesitter, and a custom Heirline statusline.

### Plugins

| File | Plugins / Purpose |
|------|-------------------|
| `lua/plugins/editor.lua` | Core editor (telescope, which-key, gitsigns, etc.) |
| `lua/plugins/lsp.lua` | LSP setup via nvim-lspconfig |
| `lua/plugins/blink-cmp.lua` | Completion (blink.cmp) |
| `lua/plugins/syntax.lua` | Treesitter |
| `lua/plugins/debug.lua` | DAP + nvim-dap-ui |
| `lua/plugins/neotest.lua` | Test runner (neotest) |
| `lua/plugins/neo-tree.lua` | File explorer |
| `lua/plugins/terminal_nvim.lua` | Integrated terminal |
| `lua/plugins/ui.lua` | UI enhancements |
| `lua/plugins/dashboard.lua` | Start screen |
| `lua/plugins/heirline/` | Statusline, tabline, statuscolumn |

### LSP Servers

| Config | Server |
|--------|--------|
| `lsp/pylance.lua` | Python (Pylance) |
| `lsp/ruff.lua` | Python linting (ruff) |
| `lsp/lua_ls.lua` | Lua |
| `lsp/rust_analyzer.lua` | Rust |
| `lsp/ltex_plus.lua` | LaTeX / grammar (ltex-plus) |

### Key Modules

| Module | Purpose |
|--------|---------|
| `lua/options.lua` | Vim options (tabs, line numbers, etc.) |
| `lua/autocommands.lua` | Autocommands |
| `lua/diagnostics-config.lua` | Diagnostic signs and float config |
| `lua/session.lua` | Session persistence |
| `lua/grep.lua` | Custom grep integration |
| `lua/dap-config.lua` | DAP adapter configuration |
| `viml/mappings.vim` | Keymaps |
| `viml/commands.vim` | Custom commands |

### Installation

```powershell
# Copy nvim config
$dest = "$env:LOCALAPPDATA\nvim"
Copy-Item -Recurse -Force .\nvim\* $dest

# Open Neovim — lazy.nvim will auto-install plugins on first launch
nvim
```
