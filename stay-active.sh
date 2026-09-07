#!/usr/bin/env bash
# stay-active.sh — keep this Mac awake + Slack "active" (green dot).
# Option A of the stay-active playbook. Pair it with the real-signal cadence
# in stay-active-playbook.md (Option B) so the green dot isn't hollow.
#
# Usage:
#   stay-active            # run until Ctrl-C (or you close the terminal)
#   stay-active 8          # run for 8 hours, then auto-stop
#   stay-active 7.5 &      # run in background for 7.5h
#
# Stop: Ctrl-C  — or from another window:  pkill -f stay-active
#
# Notes:
#   * Keep the lid OPEN and on AC power. caffeinate can't beat a closed lid on battery.
#   * caffeinate -d keeps the display on, so the screen never idles -> never auto-locks.
#   * The cursor nudge uses randomized timing + distance to avoid the
#     "perfectly mechanical jiggle" pattern that monitoring tools flag.

set -uo pipefail

HOURS="${1:-0}"   # 0 = run indefinitely

# --- preflight: cliclick is what generates the input signal Slack reads ---
if ! command -v cliclick >/dev/null 2>&1; then
  echo "x cliclick not found - it nudges the cursor so Slack stays green."
  echo "  Install:  brew install cliclick"
  echo "  Then:     System Settings > Privacy & Security > Accessibility"
  echo "            -> enable your terminal app (Terminal / iTerm / Ghostty)."
  exit 1
fi

# --- keep the Mac awake; -w \$\$ ties it to THIS script so it dies when we do ---
caffeinate -d -i -w $$ &
CAFF_PID=$!

cleanup() {
  kill "$CAFF_PID" 2>/dev/null || true
  echo ""
  echo "stopped - caffeinate released. Mac will sleep/lock normally again."
}
trap cleanup EXIT INT TERM

# --- end time ---
if [ "$HOURS" != "0" ]; then
  SECS=$(awk "BEGIN{printf \"%d\", $HOURS*3600}")
  END=$(( $(date +%s) + SECS ))
else
  END=0
fi

echo "stay-active running (pid $$)."
if [ "$END" != "0" ]; then echo "  auto-stops in ${HOURS}h"; else echo "  runs until Ctrl-C"; fi
echo "  lid OPEN + on AC power for this to hold."
echo "  stop: Ctrl-C   (or elsewhere: pkill -f stay-active)"
echo ""

# --- jiggle loop ---
while true; do
  DX=$(( (RANDOM % 3) + 1 ))                 # 1-3 px
  cliclick "m:+${DX},+0" "m:-${DX},+0" >/dev/null 2>&1 || true

  if [ "$END" != "0" ] && [ "$(date +%s)" -ge "$END" ]; then
    echo "reached ${HOURS}h - stopping."
    exit 0
  fi

  SLEEP=$(( (RANDOM % 46) + 45 ))            # 45-90s
  sleep "$SLEEP"
done
