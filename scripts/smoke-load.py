#!/usr/bin/env python3
"""Load a packaged plugin the way CPA does (dlopen) and check its C entry point.

Usage: smoke-load.py <package.zip> <expected-library-name>
Exits non-zero when the archive layout is wrong or the library cannot be loaded.
"""
import ctypes
import pathlib
import sys
import tempfile
import zipfile

archive, expected = pathlib.Path(sys.argv[1]), sys.argv[2]
with zipfile.ZipFile(archive) as bundle:
    names = bundle.namelist()
    if names != [expected]:
        sys.exit(f"archive must contain exactly {expected} at its root, found {names}")
    with tempfile.TemporaryDirectory() as tmp:
        bundle.extract(expected, tmp)
        library = ctypes.CDLL(str(pathlib.Path(tmp) / expected), mode=ctypes.RTLD_LOCAL)
        for symbol in ("cliproxy_plugin_init",):
            getattr(library, symbol)
print(f"ok: {archive.name} loads and exports cliproxy_plugin_init")
