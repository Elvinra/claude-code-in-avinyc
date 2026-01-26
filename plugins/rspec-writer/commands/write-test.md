---
name: rspec:write-test
description: Write RSpec tests for Rails applications
argument-hint: "[model|request|system|job|mailer|channel] ClassName"
---

Write RSpec tests for: $ARGUMENTS

Delegate to the appropriate agent:
- For **model specs** (validations, scopes, methods): use the `model-spec-writer` agent
- For **all other spec types** (request, system, job, mailer, channel): use the `spec-writer` agent

Pass the target (class name or file path) and any specific focus areas to the agent.
