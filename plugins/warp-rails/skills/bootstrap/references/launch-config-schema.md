# Warp Launch Configuration Schema

Launch configurations are YAML files that define window, tab, and pane layouts with startup commands.

## File Location

- **macOS:** `~/.warp/launch_configurations/`
- **Windows:** `%APPDATA%\warp\Warp\data\launch_configurations\`
- **Linux:** `${XDG_DATA_HOME:-$HOME/.local/share}/warp-terminal/launch_configurations/`

Project-local configs can also be stored in `.warp/launch_configurations/` within a repository.

## Schema

```yaml
name: string              # Configuration name (required)
windows:                  # Array of window definitions
  - tabs:                 # Array of tab definitions
      - title: string     # Tab display name
        color: string     # Tab color (see colors below)
        layout:
          cwd: string     # Working directory (MUST be absolute path)
          commands:       # Array of startup commands
            - string
          split_direction: string  # "vertical" or "horizontal"
          panes:          # Nested pane definitions
            - cwd: string
              commands:
                - string
              is_focused: boolean
active_window_index: number  # Which window opens first (0-indexed)
active_tab_index: number     # Which tab is active (0-indexed)
```

## Available Tab Colors

Warp supports ANSI color names in **lowercase**:
- `red`
- `green`
- `yellow`
- `blue`
- `magenta`
- `cyan`

**WRONG:**
```yaml
color: Green
```

**WRONG:**
```yaml
color:
  r: 34
  g: 197
  b: 94
```

**CORRECT:**
```yaml
color: green
```

## Critical Requirements

1. **Absolute paths only:** The `cwd` field MUST be an absolute path. Tilde (`~`) expansion does NOT work and will cause the config to be invisible.

2. **Empty string fallback:** Use `""` for cwd if you want the default directory.

3. **Command chaining:** Multiple commands in the `commands` array are chained with `&&` when executed.

4. **Special characters:** Commands with special characters may require double quotes.

5. **Commands use `exec:` prefix:** Each command in the array must have `exec:` prefix.

**WRONG:**
```yaml
commands:
  - "bin/dev"
```

**WRONG:**
```yaml
commands:
  - bin/dev
```

**CORRECT:**
```yaml
commands:
  - exec: bin/dev
```

## Example: Rails Development Setup

```yaml
---
name: my-rails-app
windows:
  - tabs:
      - title: Server
        color: green
        layout:
          cwd: /Users/avi/code/my-rails-app
          commands:
            - exec: bin/dev
      - title: Claude
        color: blue
        layout:
          cwd: /Users/avi/code/my-rails-app
          commands:
            - exec: claude
      - title: Shell
        color: yellow
        layout:
          cwd: /Users/avi/code/my-rails-app
      - title: Console
        color: magenta
        layout:
          cwd: /Users/avi/code/my-rails-app
          commands:
            - exec: bin/rails console
```

## Example: Split Panes

```yaml
---
name: split-example
windows:
  - tabs:
      - title: Dev
        layout:
          cwd: /Users/avi/code/app
          split_direction: horizontal
          panes:
            - cwd: /Users/avi/code/app
              commands:
                - exec: bin/dev
            - cwd: /Users/avi/code/app
              commands:
                - exec: tail -f log/development.log
              is_focused: true
```

## Launching Configurations

- **Command Palette:** Type "Launch Configuration"
- **Keyboard:** `Ctrl-Cmd-L` (macOS)
- **Right-click:** Click `+` tab button
- **URI Scheme:** `warp://launch/config-name.yaml`
- **Raycast/Alfred:** Use Warp extensions
