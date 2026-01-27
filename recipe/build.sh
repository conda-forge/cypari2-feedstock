#!/bin/bash
set -ex

$PYTHON -m build --wheel --no-isolation --skip-dependency-check \
    -Cbuilddir=builddir \
    -Csetup-args=-Dpari_datadir="$PREFIX/share/pari" \
    -Csetup-args=${MESON_ARGS// / -Csetup-args=} \
    || (cat builddir/meson-logs/meson-log.txt && exit 1)

$PYTHON -m pip install --find-links dist cypari2
