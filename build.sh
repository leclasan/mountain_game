#!/bin/bash
set -e

rm -rf builds
mkdir -p builds
godot --headless --export-release Web ./builds/mountain
mv ./builds/mountain.html ./builds/index.html
cd builds
zip mountain.zip *

# butler push leclasan/mountain-game:html
