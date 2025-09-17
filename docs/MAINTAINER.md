# Maintainer Guide

This document explains how to maintain the starter scripts in this repository, especially around obtaining and running the `coder` binary safely (without committing the executable).

## Repository Overview

Scripts:
- `start.linux.sh`: Generic Linux startup script (multi-method install logic: direct download, apt fallback, manual instructions).
- `start.mac.sh`: macOS startup script (direct download or Homebrew fallback).
- `start.windows.sh`: Windows (Git Bash / WSL) helper script (direct download or winget fallback, resets embedded PostgreSQL dir).
- `start.gh.codespaces.sh`: Purpose-built for GitHub Codespaces. No sudo/apt. Downloads the latest `coder` into `.bin/` and starts the server.

Supporting docs:
- `README.md` and `docs/QUICK_START.md` (user-oriented).
- This `docs/MAINTAINER.md` (you are here).

## Key Maintenance Principles
1. **Never commit the `coder` executable** – `.gitignore` excludes `coder`, `coder.exe`, archives, and `.bin/`.
2. **Keep logic deterministic & safe** – Avoid privileged operations (especially in Codespaces) and isolate downloaded binaries in `.bin/`.
3. **Minimize user friction** – A single command should stand up a local Coder instance for evaluation/testing.
4. **Allow explicit version pinning (future-friendly)** – The Codespaces script can be extended to support `CODER_VERSION` env var.

## Current Improvements (as of v2.25.2 Work)
- Added `.bin/` directory for downloaded binaries.
- Hardened Codespaces script with:
  - `set -euo pipefail` and sanitized `IFS`.
  - Robust version detection (GitHub API + redirect fallback).
  - Temp-directory extraction; safe binary discovery via `find`.
  - Environment toggles: `SKIP_CODER_SERVER=1`, `QUIET=1`.
- Updated `.gitignore` to prevent accidental commits of binaries and archives.
- Removed previously tracked `coder` binary from the index (`git rm --cached coder`).

## Upgrading the Coder Version
Typical flow (Codespaces or local dev):
```bash
# Force redownload latest (remove existing binary)
rm -f .bin/coder
SKIP_CODER_SERVER=1 bash start.gh.codespaces.sh
```
To pin a version (proposed enhancement):
1. Implement support inside `start.gh.codespaces.sh` to honor `CODER_VERSION` if set.
2. Use:
   ```bash
   CODER_VERSION=v2.26.0 SKIP_CODER_SERVER=1 bash start.gh.codespaces.sh
   ```
3. Commit only the script changes, never the binary.

## Verifying Integrity (Optional Enhancement)
Add checksum verification:
1. Download checksum file:
   ```bash
   curl -fsSL -o checksums.txt https://github.com/coder/coder/releases/download/${VERSION}/coder_${VERSION#v}_checksums.txt
   ```
2. Extract the relevant line and verify with `sha256sum`.
3. Fail fast if mismatch.

## Adding Checksum Support (Pseudo-Patch Snippet)
```bash
# After determining $url and $version_no_v
checksum_url="https://github.com/coder/coder/releases/download/${latest}/coder_${version_no_v}_checksums.txt"
if curl -fsSL -o "$tmpdir/checksums.txt" "$checksum_url"; then
  expected=$(grep "coder_${version_no_v}_${platform}.tar.gz" "$tmpdir/checksums.txt" | awk '{print $1}')
  actual=$(sha256sum "$tarfile" | awk '{print $1}')
  if [ "$expected" != "$actual" ]; then
    echo "Checksum mismatch!" >&2
    rm -rf "$tmpdir"; return 1
  fi
else
  log "Warning: could not fetch checksum file; continuing without verification."
fi
```

## Cleaning Accidental Binary Commits
If a binary slipped into history and you need to purge it:
```bash
pip install git-filter-repo
git filter-repo --invert-paths --path coder --path coder.exe --path .bin/coder
# Force push (coordinate with team!)
git push --force origin develop
```

## Health Check Idea (Future)
After starting the server, poll a local endpoint:
```bash
for i in {1..20}; do
  if curl -fsS http://127.0.0.1:3000/ >/dev/null 2>&1; then
    echo "Coder is responding"; break
  fi
  sleep 1
  [ $i -eq 20 ] && echo "Coder did not become healthy in time" >&2
done
```

## Environment Flags Summary
| Variable | Purpose | Default |
|----------|---------|---------|
| `SKIP_CODER_SERVER` | Skip launching server (download/verify only) | 0 |
| `QUIET` | Suppress non-critical logs | 0 |
| (Planned) `CODER_VERSION` | Pin specific version instead of latest | (unset) |

## Common Troubleshooting
| Symptom | Cause | Fix |
|---------|-------|-----|
| API rate limit when fetching latest | GitHub API throttling | Fallback redirect already implemented; consider `CODER_VERSION` pin |
| Extraction fails | Corrupted download | Remove archive & retry; add checksum step |
| Binary not executing | Missing exec bit | `chmod +x .bin/coder` |
| Wrong architecture | Rosetta/arm mismatch | Manually set `CODER_FORCE_ARCH=linux_amd64` (future enhancement) |

## Maintenance Checklist (Per Update Cycle)
1. Test download in a clean Codespace (`rm -rf .bin && SKIP_CODER_SERVER=1 bash start.gh.codespaces.sh`).
2. Launch normally (`bash start.gh.codespaces.sh`).
3. Verify `.gitignore` still excludes artifacts.
4. Optionally bump docs to reflect version tested.
5. Commit only script & doc changes.

## License Notes
Binary artifacts from upstream aren't redistributed here—only fetched on demand. Respect upstream licensing (see `LICENSE` in extracted archive for details; not committed).

---
Maintainer doc last updated: 2025-09-17
