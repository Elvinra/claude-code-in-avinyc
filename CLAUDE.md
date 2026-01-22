# CLAUDE.md

This file provides guidance to Claude Code when working with this repository.

## Overview

This is a Claude Code plugin marketplace for Ruby, Rails, and SaaS development. It contains 8 plugins with 11 skills and 8 commands that extend Claude Code with specialized capabilities.

## Repository Structure

```
.claude-plugin/
  marketplace.json           # Marketplace manifest (v1.2.0)

plugins/
  rspec-writer/
    .claude-plugin/plugin.json
    commands/write-test.md        # "/" command wrapper
    skills/write-test/SKILL.md    # Skill with full instructions
    skills/write-test/patterns/   # Supporting reference files

  rails-frontend/
    .claude-plugin/plugin.json
    commands/hotwire.md           # "/" command wrapper
    skills/hotwire/SKILL.md
    skills/tailwind/SKILL.md      # Skill-only (no command)

  rails-expert/
    .claude-plugin/plugin.json
    skills/rails/SKILL.md         # Skill-only (no command)

  design-system/
    .claude-plugin/plugin.json
    commands/web-design.md        # "/" command wrapper
    skills/web-designer/SKILL.md
    skills/ux-ui/SKILL.md         # Skill-only (no command)

  saas-metrics/
    .claude-plugin/plugin.json
    commands/business.md          # "/" command wrapper
    commands/marketing.md         # "/" command wrapper
    skills/business/SKILL.md
    skills/marketing/SKILL.md

  tech-writer/
    .claude-plugin/plugin.json
    commands/write.md             # "/" command wrapper
    skills/write/SKILL.md

  compound-analyzer/
    .claude-plugin/plugin.json
    commands/analyze.md           # "/" command wrapper
    skills/analyze/SKILL.md

  plan-interview/
    .claude-plugin/plugin.json
    commands/interview.md         # "/" command wrapper
    skills/interview/SKILL.md
```

## Plugin Architecture

### Commands vs Skills

This marketplace uses both commands and skills. Understanding the difference is critical:

| Aspect | Commands | Skills |
|--------|----------|--------|
| Location | `commands/*.md` | `skills/*/SKILL.md` |
| "/" autocomplete | Yes | No |
| Auto-detection | No | Yes (based on conversation) |
| User invokes with | `/command-name args` | Just describe what you need |
| Purpose | Discoverability | Contextual knowledge |

**Pattern:** Action-oriented features get BOTH a skill (for auto-detection) and a thin command wrapper (for "/" discoverability). Contextual knowledge features get skills only.

### When to Create a Command

Create a command wrapper when the skill represents an **action** the user would explicitly invoke:
- `/write-test model User` - explicit action
- `/analyze this workflow` - explicit action
- `/interview this plan` - explicit action

Skip the command when the skill is **contextual knowledge** that should auto-trigger:
- `rails` - best practices applied automatically when discussing Rails
- `tailwind` - styling knowledge applied automatically
- `ux-ui` - usability principles applied automatically

### Command Wrapper Template

Commands are thin wrappers that invoke skills:

```markdown
---
name: command-name
description: Brief action description (5-10 words)
argument-hint: "[args]"
---

Invoke the plugin-name:skill-name skill for: $ARGUMENTS
```

### Marketplace Manifest

`.claude-plugin/marketplace.json` defines:
- Marketplace name and owner
- Version (currently 1.2.0)
- Array of plugins with source paths and metadata

### Plugin Manifest

Each plugin has `.claude-plugin/plugin.json`:
```json
{
  "name": "plugin-name",
  "description": "What the plugin does",
  "version": "1.0.0",
  "author": { "name": "Avi Flombaum" },
  "keywords": ["relevant", "tags"]
}
```

### Skill Definition

Skills use YAML frontmatter in `SKILL.md`:
```yaml
---
name: skill-name
description: When to trigger this skill (include trigger phrases)
argument-hint: "[optional args]"
user-invocable: true
---

# Skill Title

Instructions for the skill...
```

## Current Plugins Summary

| Plugin | "/" Commands | Skills (auto-triggered) | Purpose |
|--------|--------------|------------------------|---------|
| rspec-writer | `/write-test` | write-test | Generate RSpec tests |
| rails-frontend | `/hotwire` | hotwire, tailwind | Turbo, Stimulus, Tailwind |
| rails-expert | - | rails | POODR and Refactoring Ruby |
| design-system | `/web-design` | web-designer, ux-ui | Visual design and usability |
| saas-metrics | `/business`, `/marketing` | business, marketing | LTV, CAC, funnels |
| tech-writer | `/write` | write | Blog posts, tutorials |
| compound-analyzer | `/analyze` | analyze | Automation opportunities |
| plan-interview | `/interview` | interview | Socratic questioning |

## Adding New Plugins

1. Create `plugins/<name>/.claude-plugin/plugin.json`
2. Add skills under `plugins/<name>/skills/<skill-name>/SKILL.md`
3. If the skill is action-oriented, add a command wrapper in `plugins/<name>/commands/<command-name>.md`
4. Register in `.claude-plugin/marketplace.json`
5. Update README.md with plugin documentation

## Key Conventions

- All plugins are MIT licensed
- Skills should include trigger phrases in descriptions
- Use `argument-hint` for skills that accept arguments
- Pattern files go in subdirectories under the skill
- Action-oriented skills get command wrappers for "/" discoverability
- Contextual knowledge skills remain skill-only (auto-triggered)
