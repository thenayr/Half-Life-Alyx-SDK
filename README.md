# Half-Life Alyx SDK Description
The purpose of this repo is to automate the process of enabling the SteamVR environments tools to be used to create and compile maps for use with Half Life Alyx.  Big credit for this script goes to Gvarados [twitch](https://www.twitch.tv/gvarados) as I learned how to do this by watching his live stream while he set this up and painstakingly recreated it on my own.

# How-To Use
This repo includes a batch (.bat) script that you can run on your machine to faciliate the creation of a Alyx SDK sourcemod.  This can be run as a standalone application that will enable you to use all of the Half-Life Alyx assets to start creating custom Half Life Alyx maps before the official toolkit arrives!  This works because the existing SteamVR environments editor is ALSO based on source 2 and fairly compatible with HL Alyx assets.

## Run the hl-alyx-sdk-setup.bat script
The script tries to make some assumptions about where your steam/alyx/steamvr installs are located, but should prompt you if any/all of those don't exist and you will need to manually enter the path.  The script will copy over files that it needs (~2GB) to launch the editor. 

## Follow additional instructions at the end of .bat script
Please note that the SDK that gets created DOES NOT include the HL Alyx assets,  these come from `pak_01.dir` in your EXISTING ACTUAL `Half-Life Alyx/game/hlvr` directory.  This script does nothing to automate the extraction of those assets into the newly created `Half-Life Alyx SDK` directory.   This is a manual process and you will have to use a tool like GCFScape or VRF to extract the folders from the VPK file into the `Half-Life Alyx SDK/game/hlvr/` directory created by this script. 

You MUST ALSO download the `.FGD` files required by Half-Life Alyx to load entities into Hammer or none of the assets will work correctly on your map.  You can download those from [Gvarados1 FGD repo](https://github.com/gvarados1/Half-Life-Alyx-FGD)

## Modify and run Editor launch script
Edit the `launch-hl-alyx.bat` file and update the path to match your `sourcemods` directory.  Double click the bat file to launch the editor.

# Compiling maps
Maps *should* compile from the hammer editor, note that you will have to COPY them over to your REAL Half-Life Alyx maps folder in order to actually try them out.  This is possible with +sv_cheats and the `map` command in the console of Half Life Alyx.  

# Why?
Valve initially promised us SDK tools that would launch side-by-side with Half-Life Alyx, but it turns out that wasn't the case, although they have now informed us they are hard at work at releasing the SDK and/or editor.

# DISCLAIMER
I'm not responsible for anything that happens to your machine if you run this script, please don't sue me.  In addition I'm a complete novice to the Hammer editor, so I have no notion of what is/isn't functioning properly when it comes to that,  but basic world building and assett dropping seems to be working perfectly fine. 