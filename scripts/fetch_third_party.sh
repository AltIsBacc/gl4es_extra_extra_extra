#!/bin/sh
# Fetches the pinned glslang / SPIRV-Cross used by src/gl/spvconv (run from the repo root).
# Registers them as git submodules when run inside a git checkout.
set -e
TAG=vulkan-sdk-1.4.363.0
mkdir -p third_party
for r in glslang SPIRV-Cross; do
  [ -d third_party/$r/.git ] || [ -f third_party/$r/.git ] && continue
  git clone --depth 1 --branch $TAG https://github.com/KhronosGroup/$r third_party/$r
  git submodule add https://github.com/KhronosGroup/$r third_party/$r 2>/dev/null || true
done
