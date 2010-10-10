#!/bin/sh

# modcraft.sh is a painfully simple Minecraft mod installer.
#
# PREREQUISITES
#
#   modcraft.sh assumes the following things:
#
#     1. You are using OSX
#     2. The executable `jar` is in your PATH
#      
#  
# INSTALLATION
#
#   Place this anywhere you like so long as it's in your PATH. Then run:
#   
#     `chmod +x modcraft.sh`
#
#   to make modcraft.sh executable
#
#
# USAGE
#   
#   Install mods by making a folder called 'mods':
#   
#     ~/Library/Application Support/minecraft/mods/
#   
#   and placing any .class files there. You cannot use subdirectories within
#   the /mods folder so just put all the .class files together

#   For example, to install the Better Grass mod, I must place 
#   the my.class from the mod into  :
#     
#     ~/Library/Application Support/minecraft/mods/my.class

set -e

minecraft="/Users/`whoami`/Library/Application Support/minecraft" 

if [ ! -d "$minecraft" ]; then
  echo "[ERROR] Couldn't find Minecraft folder."
  exit 1
fi

if [ ! -f "$minecraft/bin/minecraft.jar" ]; then
  echo "[ERROR] Couldn't find minecraft.jar"
fi
  
# Unpack jar
echo "1. Creating temporary directory..."
if [ -d "$minecraft/tmp" ]; then
  rm -rf "$minecraft/tmp"
fi

mkdir "$minecraft/tmp"
cd "$minecraft/tmp"

echo "2. Extracting minecraft.jar into temporary directory..."
jar xf "$minecraft/bin/minecraft.jar"

# Copy in all mods
# Find .class files recursively and copy in each one
echo "3. Finding mods..."

cd "$minecraft/mods"

for mod in "$minecraft/mods"/*; do
  echo "\tFound modification: $mod"
  cp "$mod" "$minecraft/tmp"
done

# Delete MOJANGs from extracted minecraft.jar
if [ -f "$minecraft/tmp/META-INF/MOJANG_C.DSA" ]; then
  rm "$minecraft/tmp/META-INF/MOJANG_C.DSA"
fi
  
if [ -f "$minecraft/tmp/META-INF/MOJANG_C.SF" ]; then
  rm "$minecraft/tmp/META-INF/MOJANG_C.SF"
fi

# Rejar it
echo "4. Packing minecraft.jar back up"

cd "$minecraft/bin"
jar cf minecraft.jar -C ../tmp ../tmp/*

# Remove MCDIR
echo "5. Cleaning up..."
rm -rf "$minecraft/tmp"

echo "Completed"