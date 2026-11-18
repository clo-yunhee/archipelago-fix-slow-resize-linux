#!/bin/bash

PY_VER=3.12
GIT_TAG=0.6.8

GIT_REPOSITORY=https://github.com/ArchipelagoMW/Archipelago
APPIMAGETOOL=https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage

# Clean up remains if needed
rm -rf Archipelago Archipelago-source

# Clone the Archipelago repo
git clone --depth 1 --branch $GIT_TAG $GIT_REPOSITORY Archipelago-source
cd Archipelago-source

# The patch applies the workaround mentioned in https://github.com/kivy/kivy/issues/9106 to KVUI
git apply ../fix-slow-resize-on-linux.patch

# Setup the build environment
python$PY_VER -m venv .venv
source .venv/bin/activate

python ModuleUpdate.py -y

# Build executables
python setup.py build_exe -y
cp -r build/exe.linux* ../Archipelago

# Build AppImage
curl -Lo appimagetool $APPIMAGETOOL
chmod +x appimagetool
python setup.py bdist_appimage -y
cp dist/Archipelago_*_linux-x86_64.AppImage ..

# Delete source dir
cd ..
rm -rf Archipelago-source
