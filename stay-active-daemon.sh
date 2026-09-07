#!/usr/bin/env bash
# stay-active-daemon.sh
# Auto keep-awake + Slack "active" (green dot), WEEKDAYS 09:00-17:00 US Eastern.
# Started automatically by launchd (com.imran.stayactive) at login and kept alive.
# Self-gates on Eastern time via TZ=America/New_York, so it is correct no matter
# what timezone the laptop is set to and it follows EST/EDT automatically.
#
# Turn off / remove: see stay-active-playbook.md ("Turn it off").

LOG="$HOME/workspace/tools/stay-active.log"
CLICLICK="/opt/homebrew/bin/cliclick"
CAFF_PID=""
WARNED=0

log() { echo "$(TZ=America/New_York date '+%Y-%m-%d %H:%M:%S ET') | $1" >> "$LOG"; }

start_caff() {
  if [ -z "$CAFF_PID" ] || ! kill -0 "$CAFF_PID" 2>/dev/null; then
    caffeinate -d -i -w $$ &        # no display sleep, no idle sleep; dies with daemon
    CAFF_PID=$!
    log "WINDOW OPEN   -> keep-awake on (caffeinate pid $CAFF_PID)"
  fi
}
stop_caff() {
  if [ -n "$CAFF_PID" ] && kill -0 "$CAFF_PID" 2>/dev/null; then
    kill "$CAFF_PID" 2>/dev/null
    log "WINDOW CLOSED -> keep-awake off"
  fi
  CAFF_PID=""
}
cleanup() { stop_caff; log "daemon stopping"; exit 0; }
trap cleanup INT TERM

log "daemon started (pid $$)"
while true; do
  DOW=$(TZ=America/New_York date +%u)               # 1=Mon ... 7=Sun
  HM=$((10#$(TZ=America/New_York date +%H%M)))      # e.g. 1130, base-10 forced

  if [ "$DOW" -le 5 ] && [ "$HM" -ge 900 ] && [ "$HM" -lt 1700 ]; then
    start_caff
    DX=$(( (RANDOM % 3) + 1 ))                       # 1-3 px nudge
    ERR=$("$CLICLICK" "m:+${DX},+0" "m:-${DX},+0" 2>&1 >/dev/null)
    if echo "$ERR" | grep -qi "accessibilit"; then
      if [ "$WARNED" -eq 0 ]; then
        log "ERROR: cliclick has NO Accessibility permission - cursor is NOT moving, Slack WILL go away. Fix: System Settings > Privacy & Security > Accessibility > add cliclick."
        WARNED=1
      fi
    else
      [ "$WARNED" -eq 1 ] && log "OK: cliclick working again - jiggle active."
      WARNED=0
    fi
    sleep $(( (RANDOM % 46) + 45 ))                  # 45-90s while in window
  else
    stop_caff
    sleep 120                                        # check every 2 min when off
  fi
done
