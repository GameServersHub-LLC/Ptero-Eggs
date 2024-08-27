#! /bin/bash
echo "Path Of Titans Egg by GameServersHub"
echo "LLC 2017 GameServersHub.com"
echo "Checking for updates"
export INSTALL_DIR="./"
export DOTNET_BUNDLE_EXTRACT_BASE_DIR=./temp/
./AlderonGamesCmd --game path-of-titans --server true --beta-branch $BETA_BRANCH --install-dir .
echo "Starting server"
UE_TRUE_SCRIPT_NAME=$(echo \"$0\" | xargs readlink -f)
UE_PROJECT_ROOT=$(dirname "$UE_TRUE_SCRIPT_NAME")
chmod +x "$UE_PROJECT_ROOT/PathOfTitans/Binaries/Linux/PathOfTitansServer-Linux-Shipping"
"$UE_PROJECT_ROOT/PathOfTitans/Binaries/Linux/PathOfTitansServer-Linux-Shipping" PathOfTitans -log -Port=$SERVER_PORT -BranchKey=$BETA_BRANCH -AuthToken=$AG_AUTH_TOKEN -ServerGUID=$SERVER_GUID -Database=$DATABASE
