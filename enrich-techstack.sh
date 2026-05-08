#!/usr/bin/env bash
# Enrich any CSV with tech stack data using TechSight CLI.
# Usage: ./enrich-techstack.sh input.csv output.csv [domain_col] [tech_col]
#
# Defaults: domain_col="domain", tech_col="enr_tech_stack"
# Output: comma-separated tech names per row, skips rows already populated.
# Add --overwrite to replace existing values.

set -euo pipefail

INPUT="${1:-}"
OUTPUT="${2:-}"
DOMAIN_COL="${3:-domain}"
TECH_COL="${4:-enr_tech_stack}"
TECHSIGHT="$HOME/workspace/tools/bin/techsight"

if [[ -z "$INPUT" || -z "$OUTPUT" ]]; then
  echo "Usage: enrich-techstack.sh <input.csv> <output.csv> [domain_col] [tech_col]"
  echo "  domain_col default: domain"
  echo "  tech_col default:   enr_tech_stack"
  exit 1
fi

if [[ ! -f "$INPUT" ]]; then
  echo "Error: input file not found: $INPUT"
  exit 1
fi

echo "TechSight enrichment: $INPUT → $OUTPUT"
echo "  Domain column: $DOMAIN_COL"
echo "  Tech column:   $TECH_COL"
echo "  Workers:       50 concurrent"
echo ""

"$TECHSIGHT" enrich \
  -i "$INPUT" \
  -o "$OUTPUT" \
  --domain-col "$DOMAIN_COL" \
  --tech-col "$TECH_COL" \
  --max-workers 50

echo ""
echo "Done. Output: $OUTPUT"
