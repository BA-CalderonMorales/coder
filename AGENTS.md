# AGENTS.md - Coder Starter Scripts

## Quick Reference

- **Purpose**: Local development helper scripts
- **Docs**: `docs/` (permanent), `tmp/` (temporary, gitignored)

## Repository Structure

```
docs/       # Permanent documentation (lowercase)
tmp/        # Temporary files (never committed)
```

## Documentation Rules

1. **Root .md files**: Only README.md, CONTRIBUTING.md, LICENSE.md, CHANGELOG.md, AGENTS.md
2. **tmp/ folder**: One-off .md files, never commit to git
3. **docs/ folder**: Permanent documentation, lowercase naming

## tmp/ Folder Usage

For: one-off markdown, temporary docs, drafts, notes, issue tracking

The `tmp/` folder is never committed to git.

## Working Rules

- Stop and explain before major architectural changes
- One change per commit, commit before starting next
- Do not bundle unrelated work into the same commit
