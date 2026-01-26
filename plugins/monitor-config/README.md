# monitor-config

Configure and optimize multi-monitor setups on macOS using displayplacer.

## Installation

```bash
/plugin install monitor-config@claude-code-in-avinyc
```

## Usage

### Slash Command

```bash
/avinyc:monitor-config
```

### Natural Language

Just ask Claude to configure your monitors:

- "Optimize my monitors"
- "Configure my displays"
- "Set up my screens"
- "Rotate my left monitor to portrait"

## What It Does

Guides you through an interactive interview to understand your setup:

1. **Discovers displays** via `displayplacer list`
2. **Asks about physical arrangement** (which monitor is center, left, right)
3. **Asks about use case** (coding, video editing, gaming)
4. **Recommends optimal settings** based on your workflow
5. **Applies configuration** with a single command
6. **Saves as reusable profile** for quick switching

## Example Session

```
User: optimize my monitors

Claude: Let me check your connected displays...

I found 3 displays:
1. MacBook Pro 16" - Built-in Liquid Retina XDR
2. Dell S3225QS - 32" 4K @ 120Hz capable
3. Dell U2720Q - 27" 4K @ 60Hz capable

How are these physically arranged?

User: The 32" is center, 27" is on my left rotated vertical, MacBook on right

Claude: At 2.5 feet from 4K displays, here's what I recommend:
- 32" center: 3840x2160 @ 120Hz (full 4K, maximum sharpness)
- 27" left: 1800x3200 portrait @ 60Hz (tons of code lines visible)
- MacBook right: Native Retina @ 120Hz

Want me to apply this?
```

## Saved Profiles

Configurations are saved to `~/.config/display-profiles/` as shell scripts:

```bash
# Quick switch to your coding setup
~/.config/display-profiles/coding.sh
```

## Requirements

- macOS
- `displayplacer` CLI tool (will prompt to install via Homebrew if missing)

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Monitor shows upside down | Change rotation from `degree:90` to `degree:270` |
| Resolution mode not found | Check `displayplacer list` for exact available modes |
| Display IDs changed | Use serial screen IDs (start with 's') for reliability |

## License

MIT
