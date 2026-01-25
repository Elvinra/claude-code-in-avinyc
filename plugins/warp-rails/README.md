# warp-rails

Bootstrap Warp terminal configuration for Rails projects with colored tabs.

## Installation

```bash
/plugin install warp-rails@claude-code-in-avinyc
```

## Usage

### Slash Command

```bash
/warp-rails
```

### Natural Language

Just ask Claude to set up Warp:

- "Set up Warp for this project"
- "Configure Warp terminal"
- "Bootstrap Warp for Rails"

## What It Does

Creates a Warp launch configuration with colored tabs:

| Tab | Color | Command |
|-----|-------|---------|
| Server | green | `bin/dev` or `rails server` |
| Claude | blue | `claude` |
| Shell | yellow | (empty terminal) |
| Console | magenta | `bin/rails console` |
| Logs | cyan | `tail -f log/development.log` |
| Jobs | red | Background processor (if detected) |

You choose which tabs to include via interactive prompts.

## After Setup

Launch your configuration:
- **Keyboard:** `Ctrl-Cmd-L` then select your project
- **Direct URL:** `warp://launch/{project-name}.yaml`

## Configuration Location

Configs are saved to `~/.warp/launch_configurations/`

## Requirements

- Warp terminal (macOS)
- Rails project with standard structure

## License

MIT
