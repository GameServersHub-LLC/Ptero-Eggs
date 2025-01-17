#!/bin/bash
# steamcmd Base Installation Script
#
## just in case someone removed the defaults.
if [[ "${STEAM_USER}" == "" ]] || [[ "${STEAM_PASS}" == "" ]]; then
echo -e "steam user is not set.\n"
echo -e "Using anonymous user.\n"
STEAM_USER=anonymous
STEAM_PASS=""
STEAM_AUTH=""
else
echo -e "user set to ${STEAM_USER}"
fi
## download and install steamcmd
cd /tmp
mkdir -p /mnt/server/steamcmd
curl -sSL -o steamcmd.tar.gz https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
tar -xzvf steamcmd.tar.gz -C /mnt/server/steamcmd
mkdir -p /mnt/server/steamapps # Fix steamcmd disk write error when this folder is missing
cd /mnt/server/steamcmd
# SteamCMD fails otherwise for some reason, even running as root.
# This is changed at the end of the install process anyways.
chown -R root:root /mnt
export HOME=/mnt/server
## install game using steamcmd
./steamcmd.sh +force_install_dir /mnt/server +login ${STEAM_USER} ${STEAM_PASS} ${STEAM_AUTH} $( [[ "${WINDOWS_INSTALL}" == "1" ]] && printf %s '+@sSteamCmdForcePlatformType windows' ) +app_update ${SRCDS_APPID} $( [[ -z ${SRCDS_BETAID} ]] || printf %s "-beta ${SRCDS_BETAID}" ) $( [[ -z ${SRCDS_BETAPASS} ]] || printf %s "-betapassword ${SRCDS_BETAPASS}" ) ${INSTALL_FLAGS} validate +quit ## other flags may be needed depending on install. looking at you cs 1.6
## set up 32 bit libraries
mkdir -p /mnt/server/.steam/sdk32
cp -v linux32/steamclient.so ../.steam/sdk32/steamclient.so
## set up 64 bit libraries
mkdir -p /mnt/server/.steam/sdk64
cp -v linux64/steamclient.so ../.steam/sdk64/steamclient.so
# The Isle
mkdir -p /mnt/server/TheIsle/Saved/Config/LinuxServer
echo "Checking for existing configuration files..."

if [ ! -f "/mnt/server/TheIsle/Saved/Config/LinuxServer/Game.ini" ]; then
    wget -O /mnt/server/TheIsle/Saved/Config/LinuxServer/Game.ini https://raw.githubusercontent.com/GameServersHub-LLC/Ptero-Eggs/main/game_eggs/steamcmd/the_isle/Game.ini
else
    echo "Existing Game.ini found, skipping download..."
fi

if [ ! -f "/mnt/server/TheIsle/Saved/Config/LinuxServer/GameUserSettings.ini" ]; then
    wget -O /mnt/server/TheIsle/Saved/Config/LinuxServer/GameUserSettings.ini https://raw.githubusercontent.com/GameServersHub-LLC/Ptero-Eggs/main/game_eggs/steamcmd/the_isle/GameUserSettings.ini
else
    echo "Existing GameUserSettings.ini found, skipping download..."
fi

#Hotfix
cat > /mnt/server/TheIsle/Saved/Config/LinuxServer/Engine.ini << ENDOFFILE
[Core.System]
Paths=../../../Engine/Content
Paths=%GAMEDIR%Content
Paths=../../../Engine/Plugins/Runtime/SoundUtilities/Content
Paths=../../../Engine/Plugins/Runtime/Synthesis/Content
Paths=../../../Engine/Plugins/Runtime/AudioSynesthesia/Content
Paths=../../../Engine/Plugins/Runtime/WebBrowserWidget/Content
Paths=../../../Engine/Plugins/FX/Niagara/Content
Paths=../../../Engine/Plugins/Experimental/PythonScriptPlugin/Content
Paths=../../../TheIsle/Plugins/SteamCore/Content
Paths=../../../TheIsle/Plugins/RVTObjectLandscapeBlending/Content
Paths=../../../Engine/Plugins/Runtime/Nvidia/DLSS/Content
Paths=../../../TheIsle/Plugins/DonMeshPainting/Content
Paths=../../../TheIsle/Plugins/UIPF/Content
Paths=../../../TheIsle/Plugins/EOSCore/Content
Paths=../../../Engine/Plugins/Experimental/ControlRig/Content
Paths=../../../Engine/Plugins/Runtime/Nvidia/DLSSMoviePipelineSupport/Content
Paths=../../../Engine/Plugins/MovieScene/MovieRenderPipeline/Content
Paths=../../../Engine/Plugins/Compositing/OpenColorIO/Content
Paths=../../../Engine/Plugins/MovieScene/SequencerScripting/Content
Paths=../../../TheIsle/Plugins/ImpostorBaker/Content
Paths=../../../Engine/Plugins/2D/Paper2D/Content
Paths=../../../Engine/Plugins/Developer/AnimationSharing/Content
Paths=../../../Engine/Plugins/Editor/GeometryMode/Content
Paths=../../../Engine/Plugins/Editor/SpeedTreeImporter/Content
Paths=../../../Engine/Plugins/Enterprise/DatasmithContent/Content
Paths=../../../Engine/Plugins/Experimental/ChaosClothEditor/Content
Paths=../../../Engine/Plugins/Experimental/GeometryProcessing/Content
Paths=../../../Engine/Plugins/Experimental/GeometryCollectionPlugin/Content
Paths=../../../Engine/Plugins/Experimental/ChaosSolverPlugin/Content
Paths=../../../Engine/Plugins/Experimental/ChaosNiagara/Content
Paths=../../../Engine/Plugins/Experimental/MotoSynth/Content
Paths=../../../Engine/Plugins/Media/MediaCompositing/Content
Paths=../../../Engine/Plugins/Runtime/OpenXREyeTracker/Content
Paths=../../../Engine/Plugins/Runtime/OpenXR/Content
Paths=../../../Engine/Plugins/Runtime/OpenXRHandTracking/Content
Paths=../../../Engine/Plugins/VirtualProduction/Takes/Content
ENDOFFILE
chmod -R 777 /mnt/server/TheIsle/Saved/Config/LinuxServer
## install end
echo "-----------------------------------------"
echo "Installation completed..."
echo "-----------------------------------------"