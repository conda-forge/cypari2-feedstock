#!/bin/bash
set -ex

# Find cysignals include directory under the host prefix.
# We cannot rely on $SP_DIR or py.get_install_dir() because conda's
# placeholder paths may not match the actual install location, and for
# cross-compilation the host Python cannot be executed.  Using find on
# $PREFIX works in all cases.
CYSIGNALS_INCDIR=$(find "$PREFIX/lib" -type d -path "*/site-packages/cysignals" | head -1)
if [ -z "$CYSIGNALS_INCDIR" ]; then
    echo "ERROR: cysignals not found under $PREFIX"
    exit 1
fi

$PYTHON -m build --wheel --no-isolation --skip-dependency-check \
    -Cbuilddir=builddir \
    -Csetup-args=-Dpari_datadir="$PREFIX/share/pari" \
    -Csetup-args=-Dcysignals_incdir="$CYSIGNALS_INCDIR" \
    -Csetup-args=${MESON_ARGS// / -Csetup-args=} \
    || (cat builddir/meson-logs/meson-log.txt && exit 1)

$PYTHON -m pip install --find-links dist cypari2
