# Stay-Active — automatic weekday presence

Keeps the Mac awake + Slack showing **active (green)** automatically,
**Monday–Friday, 08:00–21:00 UK time**. Off evenings and weekends.
Locks onto UK time regardless of the laptop's own timezone.

## What YOU have to do
1. **One-time:** grant the small helper "cliclick" the Accessibility permission
   (see below). Without it the cursor won't move and Slack goes away.
2. **Every weekday during 08:00–21:00 UK:** leave the laptop **open and plugged
   into power.** That's it — software can't keep a closed-lid laptop awake on
   battery, and can't wake a sleeping one. Open + plugged in = it handles the rest.

That's the whole job. No commands, no daily clicking.

## The one-time permission (20 seconds)
System Settings is open at: Privacy & Security › Accessibility.
- Click the **+** button.
- Press **Cmd + Shift + G**, paste:  `/opt/homebrew/bin/cliclick`  → Open.
- Make sure its toggle is **ON**.
(A Finder window is also open with the file highlighted — you can drag it into
the list instead.)

## How it behaves
- In window (Mon–Fri 08–21 UK): keeps the Mac awake (`caffeinate`), nudges the
  cursor 1–3px every 45–90s (randomized so it doesn't look mechanical), and the
  screen never auto-locks.
- Out of window: releases everything; Mac sleeps/locks normally.
- Auto-starts at login and restarts itself if it ever stops.

## Pair with real activity (recommended)
The green dot alone is hollow — admins see *messages/output*, not the dot, and
"green for hours with zero messages" is the obvious tell. On the days you want it
airtight: ship one real deliverable early, set a Slack status, and schedule 2–3
async updates across the day (Slack: compose → ▾ next to Send → Schedule). Ask
Claude to draft these per client.

## Check it's working
- Log:  `~/workspace/tools/stay-active.log`  (shows WINDOW OPEN/CLOSED + any errors)
- Running?  `launchctl print gui/$(id -u)/com.imran.stayactive | grep state`

## Turn it off
- Pause now:   `launchctl bootout gui/$(id -u)/com.imran.stayactive`
- Remove for good: the line above, then delete
  `~/Library/LaunchAgents/com.imran.stayactive.plist`
- Re-enable:   `launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.imran.stayactive.plist`

## Manual one-off (if you ever want it outside the schedule)
`stay-active 8`  — awake + green for 8h now, `Ctrl-C` to stop.
