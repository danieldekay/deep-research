#!/usr/bin/env bash
# check-providers.sh — verifies all local services required by deep-research
# are reachable before the pipeline runs.
#
# Usage:
#   ./check-providers.sh [--profile <ollama|lmstudio|mlx>] [--config <path>]
#
# If --profile is omitted, reads config.toml to auto-detect the active profile.
# Exit code 0 = all required services reachable.
# Exit code 1 = one or more services unreachable (details printed to stdout).

set -euo pipefail

CONFIG_PATH="./config.toml"
PROFILE=""
TIMEOUT=3   # seconds per check

while [[ $# -gt 0 ]]; do
  case "$1" in
    --profile) PROFILE="$2"; shift 2 ;;
    --config)  CONFIG_PATH="$2"; shift 2 ;;
    *) echo "Unknown flag: $1" >&2; exit 1 ;;
  esac
done

# ── Auto-detect profile from config.toml ──────────────────────────────────────

if [[ -z "$PROFILE" && -f "$CONFIG_PATH" ]]; then
  MODEL_LINE=$(grep -m1 '^orchestrator' "$CONFIG_PATH" 2>/dev/null || true)
  if echo "$MODEL_LINE" | grep -q '"ollama:'; then
    PROFILE="ollama"
  elif echo "$MODEL_LINE" | grep -q '"lmstudio:'; then
    PROFILE="lmstudio"
  elif echo "$MODEL_LINE" | grep -q '"mlx:'; then
    PROFILE="mlx"
  else
    echo "✓ Cloud provider profile detected — no local services to check."
    exit 0
  fi
fi

if [[ -z "$PROFILE" ]]; then
  echo "Could not detect profile. Pass --profile <ollama|lmstudio|mlx>" >&2
  exit 1
fi

echo "Checking providers for profile: $PROFILE"
echo ""

PASS=0
FAIL=0

check() {
  local name="$1" url="$2" label="$3"
  if curl -sf --max-time "$TIMEOUT" "$url" -o /dev/null 2>/dev/null; then
    printf "  %-22s ✓ reachable   %s\n" "$name" "$label"
    PASS=$((PASS+1))
  else
    printf "  %-22s ✗ UNREACHABLE  %s\n" "$name" "$label"
    FAIL=$((FAIL+1))
  fi
}

check_port() {
  local name="$1" host="$2" port="$3" label="$4"
  if nc -z -w "$TIMEOUT" "$host" "$port" 2>/dev/null; then
    printf "  %-22s ✓ reachable   %s\n" "$name" "$label"
    PASS=$((PASS+1))
  else
    printf "  %-22s ✗ UNREACHABLE  %s\n" "$name" "$label"
    FAIL=$((FAIL+1))
  fi
}

# ── LLM backend ───────────────────────────────────────────────────────────────

echo "LLM:"
case "$PROFILE" in
  ollama)
    check "Ollama" "http://localhost:11434/api/tags" "localhost:11434  (run: ollama serve)"
    ;;
  lmstudio)
    check "LM Studio" "http://localhost:1234/v1/models" "localhost:1234  (start LM Studio → Local Server)"
    ;;
  mlx)
    check "MLX-LM" "http://localhost:8080/v1/models" "localhost:8080  (run: mlx_lm.server --model <name>)"
    ;;
esac

# ── Web search ────────────────────────────────────────────────────────────────

echo ""
echo "Web search:"
WEB_PROVIDER=$(python3 -c "
import sys
try:
    import tomllib
except ImportError:
    try:
        import tomli as tomllib
    except ImportError:
        print('tavily'); sys.exit(0)
with open('$CONFIG_PATH', 'rb') as f:
    c = tomllib.load(f)
print(c.get('providers', {}).get('web', {}).get('provider', 'tavily'))
" 2>/dev/null || echo "tavily")

if [[ "$WEB_PROVIDER" == "searxng" ]]; then
  check "SearXNG" "http://localhost:8888/search?q=test&format=json" \
    "localhost:8888  (run: docker compose up searxng)"
else
  printf "  %-22s — cloud provider (%s), skipping\n" "Web search" "$WEB_PROVIDER"
fi

# ── Scholar / references ──────────────────────────────────────────────────────

echo ""
echo "Scholar / references:"
SCHOLAR_PROVIDER=$(python3 -c "
import sys
try:
    import tomllib
except ImportError:
    try:
        import tomli as tomllib
    except ImportError:
        print('semantic_scholar'); sys.exit(0)
with open('$CONFIG_PATH', 'rb') as f:
    c = tomllib.load(f)
print(c.get('providers', {}).get('scholar', {}).get('provider', 'semantic_scholar'))
" 2>/dev/null || echo "semantic_scholar")

if [[ "$SCHOLAR_PROVIDER" == "zotero" ]]; then
  check_port "Zotero MCP" "localhost" "23119" "port:23119  (Zotero must be open with MCP bridge)"
else
  printf "  %-22s — cloud provider (%s), skipping\n" "Scholar" "$SCHOLAR_PROVIDER"
fi

# ── Summary ───────────────────────────────────────────────────────────────────

echo ""
echo "────────────────────────────────────────"
echo "  Passed: $PASS   Failed: $FAIL"
echo "────────────────────────────────────────"

if [[ $FAIL -gt 0 ]]; then
  echo ""
  echo "Fix unreachable services, then re-run this script."
  echo "Do not start the research pipeline until all required services pass."
  exit 1
else
  echo ""
  echo "All required services reachable. Pipeline is ready."
  # Write providers_verified flag into state.md if it exists
  if [[ -f "${STATE_FILE:-}" ]]; then
    sed -i.bak 's/providers_verified: false/providers_verified: true/' "$STATE_FILE"
  fi
  exit 0
fi
