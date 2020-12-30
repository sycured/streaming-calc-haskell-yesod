#!/bin/bash
set -xe

mkbuild=$(buildah from -v "$TRAVIS_BUILD_DIR":"$mntbuild"/home/hsk/to_build ghcr.io/sycured/oraclelinux-haskell-builder:latest)
mntbuild=$(buildah mount "$mkbuild")
buildah run --user root "$mkbuild" bash -c "chown -R hsk /home/hsk/to_build && yum install zlib-devel -y && stack upgrade"
buildah run "$mkbuild" -- bash -c "cd /home/hsk/to_build && stack setup && stack build --ghc-options='-fPIC -optl-pthread' --test --copy-bins"

mkimg=$(buildah from scratch)
buildah config --author='sycured' "$mkimg"
buildah config --label Name='streaming-calc-haskell-yesod' "$mkimg"
buildah config --env YESOD_HOST=0.0.0.0 "$mkimg"
buildah config --port 3000 "$mkimg"
buildah config --workingdir='/opt' "$mkimg"
buildah config --cmd '/opt/streaming-calc-haskell-yesod' "$mkimg"
mntimg=$(buildah mount "$mkimg")
yum --nogpgcheck --installroot="$mntimg" install glibc-langpack-en gmp zlib -y
mkdir -p "$mntimg"/opt/config "$mntimg"/opt/static
cp "$mntbuild"/home/hsk/.local/bin/streaming-calc-haskell-yesod "$mntimg"/opt/
buildah unmount "$mkimg"
buildah unmount "$mkbuild"
buildah rm "$mkbuild"
buildah commit --squash "$mkimg" "schy"
buildah rm "$mkimg"
