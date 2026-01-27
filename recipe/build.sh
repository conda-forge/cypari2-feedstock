#!/bin/bash
set -ex

export PARI_SHARE="$PREFIX/share/pari"

$PYTHON -m build --wheel --no-isolation --skip-dependency-check \
    -Cbuilddir=builddir -Csetup-args=${MESON_ARGS// / -Csetup-args=} \
    || (cat builddir/meson-logs/meson-log.txt && exit 1)

$PYTHON -m pip install --find-links dist cypari2
