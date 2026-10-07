Simple battery program

First I started off with a simple Linux based overlay that is aimed to run as a background process that simply shows the battery percentage with an overlay, so far what is customizable:
+ Font (line 3)
+ Battery pointer (line 4)
+ Alignment (lines 9-11)

What it does:
Updates to display battery % every 10 seconds
Might add more later, depends on time and what I choose to add, but hey it works for noe :D
Yes, this is aimed for Linux systems which have a battery connected, such as Laptops, or Desktops with a UPS, though phones could work too using bluetooth or something, go wild if your bored too I guess

Dependencies: osd_cat - Uses osd_cat to display the overlay in a preconfigured location, can be utilised as a startup script

How to use:
1. Download `battery_overlay.sh`
2. Locate and move `battery_overlay.sh` to a location of your choice
3. Customize the information and launch in terminal while experimenting
4. Give file execute permissions and setup as startup script
5. Reboot or run script without a terminal and enjoy your new overlay simple niche overlay :^

Todo:
1. More customizability such as different colour options, customizing if it should be showing "B" or "Battery", keybinds to show/hide it
2. (bugfix) fix when switching between charging and discharing, it goes poof (which is ney fun, though that might be from the true loop that would be when OSD is active)
3. Optimizing it where I can
4. Make a second extension script that would probably be even more useless on this since research shows there are already options for it :D
