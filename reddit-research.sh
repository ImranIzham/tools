#!/usr/bin/env bash
# GTM research from Reddit — find pain points, buyer language, content angles.
# Usage: ./reddit-research.sh <topic> [output_file]
#
# Examples:
#   ./reddit-research.sh "B2B SaaS accessibility compliance"
#   ./reddit-research.sh "HR software pain points" pain-points.md

set -euo pipefail

TOPIC="${1:-}"
OUTPUT="${2:-}"
REDDIT_FIND="$HOME/workspace/tools/bin/reddit-find"

if [[ -z "$TOPIC" ]]; then
  echo "Usage: reddit-research.sh <topic> [output_file]"
  echo ""
  echo "Commands available:"
  echo "  discover  -- find relevant subreddits for topic"
  echo "  fetch     -- fetch top threads from subreddits"
  echo "  search    -- search Reddit for keyword"
  echo "  post      -- deep-dive single post + all comments"
  echo ""
  echo "Direct commands:"
  echo "  reddit-find discover --topic 'HR software'"
  echo "  reddit-find fetch --subreddit humanresources --limit 20"
  echo "  reddit-find search --query 'pain points HRIS' --limit 30"
  echo "  reddit-find post --url <reddit_post_url>"
  exit 1
fi

echo "Reddit GTM Research: $TOPIC"
echo "Step 1: Discovering relevant subreddits..."
echo ""

DISCOVER_OUTPUT=$("$REDDIT_FIND" discover --topic "$TOPIC" 2>&1)
echo "$DISCOVER_OUTPUT"

if [[ -n "$OUTPUT" ]]; then
  echo "# Reddit Research: $TOPIC" > "$OUTPUT"
  echo "Date: $(date)" >> "$OUTPUT"
  echo "" >> "$OUTPUT"
  echo "## Subreddits Found" >> "$OUTPUT"
  echo "$DISCOVER_OUTPUT" >> "$OUTPUT"
  echo "" >> "$OUTPUT"
  echo "Saved to: $OUTPUT"
  echo "Next: run 'reddit-find fetch --subreddit <name> --limit 30 >> $OUTPUT' for each subreddit"
fi
