## Problem
Sometimes, I want to make the KDE panel to auto hide (for example during a video call, and/or when I am using a full screen application). But most of the time, I want to make it always visible. Going into the panel's settings each time to change the visibility mode manually is long and boring. So here is a script you can adapt and use to help you do that automatically.

## Requirements
- using KDE Plasma (I have v.6.7.1, portability of this project is not guaranteed)
- `busctl` command (normally already installed)
- `jq` command

## Solution
You can clone this repository and make the [toggle-panel-visibility.sh](./toggle-panel-visibility.sh) script executable with `chmod u+x toggle-panel-visibility.sh`.

You can try to execute the script right away. However, it may not wrk as expected. In that case, you may need to make a few verifications/changes to adapt it to your environment.

### 1. Find the panel's Containment ID
The script uses the `busctl` command to interact with the KDE Plasma panel. To do so, it needs to know the panel's Containment ID. You can find it by running the following command:
```bash
echo "CID=$(cat ~/.config/plasma-org.kde.plasma.desktop-appletsrc | grep "Applets" |\
 head -n 1 | awk -F'[][]' '{print $4}')"  
# CID=2 for me
```

### 2. Find the right attribute's name
In my case, the visibility of the pannel was named "hiding" but it can differ depending on your configuration or version. To find the right attribute's name, you can run the following command:
```bash
busctl --user call org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell evaluateScript 's'\
 "p=panelById(2); print(JSON.stringify(p, null, 2))" | sed -n 's/^s "\(.*\)"$/\1/p' |\
  sed 's/\\n/\n/g' | sed 's/\\"/"/g' | jq
```
Search for an attribute that looks like it could control the visibility of your panel and note its name and value.

### 3. Find the right values
You can use the same above command twice, once with the panel manually set to "Always visible", and once set to "Auto-hide". Compare the two outputs to find the right values to show and hide the panel.

### Adapt the script
Replace the CID, the attribute's name and the show/hide values in the script with the values you found in the previous steps. Now run the script again and it should toggle your panel visibility back and forth each time you run the script.

## Shortcut
For easier use, you can create a shortcut in your system settings. Here's how:
1. Go to `System Settings > Shortcuts`
2. Click `+ Add New > Command or script > Choose`
3. Select the script, then name the shortcut and clicl `+ Add`
4. Click `+ Add` again and assign a shortcut key to the shortcut via the `Input` button
5. Validate your shortcut with `Apply` and close the settings
6. Enjoy your new automatic panel visibility toggle!