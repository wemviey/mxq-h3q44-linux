#!/bin/sh
set -eu

KREL="$(uname -r)"
KBUILD="/lib/modules/$KREL/build"
MODDIR="/root/sunxi-nand-bbm1184"

if [ ! -d "$KBUILD" ]; then
	echo "Kernel build directory not found: $KBUILD" >&2
	exit 1
fi

cd "$MODDIR"
make -C "$KBUILD" M="$MODDIR" clean modules
modinfo "$MODDIR/sunxi_nand.ko"
