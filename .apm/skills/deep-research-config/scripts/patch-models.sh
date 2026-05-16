#!/usr/bin/env bash
# patch-models.sh — rewrites config.toml [models] (and optionally [providers.*])
# for a local provider profile.
#
# Usage:
#   ./patch-models.sh --profile <ollama|lmstudio|mlx> [--models-only] [--config <path>]
#
# Options:
#   --profile     Required. ollama | lmstudio | mlx
#   --models-only Only rewrite [models], skip [providers.*]
#   --config      Path to config.toml (default: ./config.toml)

set -euo pipefail

PROFILE=""
MODELS_ONLY=false
CONFIG_PATH="./config.toml"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --profile)     PROFILE="$2";      shift 2 ;;
    --models-only) MODELS_ONLY=true;  shift   ;;
    --config)      CONFIG_PATH="$2";  shift 2 ;;
    *) echo "Unknown flag: $1" >&2; exit 1 ;;
  esac
done

if [[ -z "$PROFILE" ]]; then
  echo "Error: --profile is required (ollama | lmstudio | mlx)" >&2
  exit 1
fi
if [[ ! -f "$CONFIG_PATH" ]]; then
  echo "Error: config not found at $CONFIG_PATH" >&2
  echo "Run the orchestrator once first to seed config.toml, or copy the reference config:" >&2
  echo "  cp .apm/skills/deep-research-config/references/config.local-${PROFILE}.toml config.toml" >&2
  exit 1
fi

# ── Model definitions per profile ─────────────────────────────────────────────

case "$PROFILE" in
  ollama)
    M_HEAVY="ollama:qwen3:32b"
    M_LIGHT="ollama:qwen3:8b"
    WEB_PROVIDER="searxng"
    SCHOLAR_PROVIDER="zotero"
    ;;
  lmstudio)
    M_HEAVY="lmstudio:heavy"   # user should edit to loaded model name
    M_LIGHT="lmstudio:light"
    WEB_PROVIDER="searxng"
    SCHOLAR_PROVIDER="zotero"
    ;;
  mlx)
    M_HEAVY="mlx:mlx-community/Qwen3-30B-A3B-4bit"
    M_LIGHT="mlx:mlx-community/Qwen3-8B-4bit"
    WEB_PROVIDER="searxng"
    SCHOLAR_PROVIDER="zotero"
    ;;
  *)
    echo "Unknown profile: $PROFILE. Choose: ollama | lmstudio | mlx" >&2
    exit 1
    ;;
esac

backup="${CONFIG_PATH}.bak.$(date +%Y%m%d_%H%M%S)"
cp "$CONFIG_PATH" "$backup"
echo "Backup: $backup"

# ── Rewrite [models] using Python (avoids sed quoting nightmares with TOML) ───

python3 - "$CONFIG_PATH" "$M_HEAVY" "$M_LIGHT" <<'PY'
import sys, re

path, heavy, light = sys.argv[1], sys.argv[2], sys.argv[3]

HEAVY_KEYS = {"orchestrator", "extract", "evaluate",
              "synthesize_brief", "synthesize_narrative", "synthesize_forward"}
LIGHT_KEYS = {"gather", "process", "cite", "capture"}

with open(path) as f:
    lines = f.readlines()

in_models = False
out = []
for line in lines:
    if re.match(r'^\[models\]', line):
        in_models = True
        out.append(line)
        continue
    if in_models and re.match(r'^\[', line):
        in_models = False

    if in_models:
        m = re.match(r'^(\w+)\s*=\s*"[^"]*"(.*)', line)
        if m:
            key, rest = m.group(1), m.group(2)
            if key in HEAVY_KEYS:
                out.append(f'{key:<21} = "{heavy}"{rest}\n')
            elif key in LIGHT_KEYS:
                out.append(f'{key:<21} = "{light}"{rest}\n')
            else:
                out.append(line)
        else:
            out.append(line)
    else:
        out.append(line)

with open(path, "w") as f:
    f.writelines(out)

print(f"[models] rewritten — heavy={heavy}  light={light}")
PY

# ── Rewrite [providers.*] unless --models-only ─────────────────────────────────

if [[ "$MODELS_ONLY" == false ]]; then
  python3 - "$CONFIG_PATH" "$WEB_PROVIDER" "$SCHOLAR_PROVIDER" <<'PY'
import sys, re

path, web, scholar = sys.argv[1], sys.argv[2], sys.argv[3]
with open(path) as f:
    lines = f.readlines()

section = ""
out = []
for line in lines:
    m = re.match(r'^\[(\S+)\]', line)
    if m:
        section = m.group(1)
    if section == "providers.web" and re.match(r'^provider\s*=', line):
        out.append(f'provider            = "{web}"\n')
        continue
    if section == "providers.scholar" and re.match(r'^provider\s*=', line):
        out.append(f'provider            = "{scholar}"\n')
        continue
    out.append(line)

with open(path, "w") as f:
    f.writelines(out)

print(f"[providers] rewritten — web={web}  scholar={scholar}")
PY
fi

echo ""
echo "✓ config.toml patched for profile: $PROFILE"
echo ""
echo "Next: verify providers are running:"
echo "  .apm/skills/deep-research-config/scripts/check-providers.sh"
