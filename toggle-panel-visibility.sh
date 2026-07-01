#!/usr/bin/env bash
set -euo pipefail

#Configuration
CID=2
attr="hiding"
hide_value="autohide"
show_value="none"

# Toggle panel
output=$(busctl --user call org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell evaluateScript 's' \
"p=panelById($CID); print(JSON.stringify({$attr:p.$attr},null,2))")

data=$(echo "$output" | sed -n 's/^s "\(.*\)"$/\1/p' | sed 's/\\n/\n/g' | sed 's/\\"/"/g')

state=$(echo "$data" | jq -r ".$attr")

busctl --user call org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell evaluateScript 's' \
"p=panelById($CID); p.$attr=('$state'==='$show_value'?'$hide_value':'$show_value');" \
>/dev/null
