#!/usr/bin/env python3
"""Build a PyYAML wheel for the running interpreter into the pip wheelhouse.

PyYAML lags newly released Pythons: when no wheel exists for the active
interpreter, mason's `pip install --ignore-installed` compiles it from source
and fails on machines without a C toolchain. Prebuilding the wheel here lets
pip pick it up through the `--find-links` entry in lua/plugins/mason.lua.

Wheels go to $PIP_WHEELHOUSE (default ~/.local/share/pip-wheelhouse). On
Windows, setuptools is steered to MinGW's gcc when MSVC is not installed;
projects whose C extension still cannot be built (PyYAML needs libyaml
headers) fall back to a pure-Python wheel, which installs fine.

The sh, cmd and nushell front ends all call this file so the logic lives in
one place.
"""

from __future__ import annotations

import json
import os
import shutil
import subprocess
import sys
import tarfile
import tempfile
import urllib.request
import zipfile
from pathlib import Path

PACKAGE = "pyyaml"
DEST = Path(
    os.environ.get("PIP_WHEELHOUSE") or Path.home() / ".local" / "share" / "pip-wheelhouse"
)


def official_wheel_exists(tmp: Path) -> bool:
    """True when pip can fetch a wheel for this interpreter from PyPI."""
    return (
        subprocess.run(
            [
                sys.executable,
                "-m",
                "pip",
                "download",
                "--quiet",
                "--disable-pip-version-check",
                "--only-binary=:all:",
                "--no-deps",
                "--dest",
                str(tmp / "official"),
                PACKAGE,
            ],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        ).returncode
        == 0
    )


def fetch_sdist(tmp: Path) -> Path:
    """Download the sdist from PyPI and return its unpacked source directory."""
    with urllib.request.urlopen(f"https://pypi.org/pypi/{PACKAGE}/json") as response:
        data = json.load(response)

    sdists = [entry for entry in data["urls"] if entry["packagetype"] == "sdist"]
    if not sdists:
        sys.exit(f"build-pyyaml: PyPI publishes no sdist for {PACKAGE}")

    url = sdists[0]["url"]
    print(f"fetching {url}")
    archive = tmp / os.path.basename(url)
    urllib.request.urlretrieve(url, archive)

    srcdir = tmp / "src"
    srcdir.mkdir()
    if archive.suffix == ".zip":
        with zipfile.ZipFile(archive) as zf:
            zf.extractall(srcdir)
    else:
        with tarfile.open(archive) as tf:
            try:
                tf.extractall(srcdir, filter="data")
            except TypeError:  # Python < 3.12 has no extraction filters
                tf.extractall(srcdir)

    entries = [entry for entry in srcdir.iterdir() if entry.is_dir()]
    if len(entries) != 1:
        sys.exit(f"build-pyyaml: unexpected sdist layout: {entries}")
    return entries[0]


def use_mingw_when_msvc_is_missing(srcdir: Path) -> None:
    """On Windows setuptools only looks for MSVC; steer it to MinGW's gcc."""
    if sys.platform != "win32" or not (srcdir / "setup.py").exists():
        return
    if shutil.which("gcc") is None:
        print("warning: no gcc on PATH, setuptools will look for MSVC", file=sys.stderr)
        return

    setup_cfg = srcdir / "setup.cfg"
    text = setup_cfg.read_text() if setup_cfg.exists() else ""
    if "[build_ext]" not in text:
        with setup_cfg.open("a", encoding="utf-8", newline="\n") as fh:
            fh.write("\n[build_ext]\ncompiler = mingw32\n")


def main() -> int:
    DEST.mkdir(parents=True, exist_ok=True)

    with tempfile.TemporaryDirectory(prefix="build-pyyaml.") as tmpdir:
        tmp = Path(tmpdir)
        if official_wheel_exists(tmp):
            print(f"{PACKAGE}: a prebuilt wheel exists for this interpreter, nothing to do")
            return 0

        print(f"{PACKAGE}: no prebuilt wheel for this interpreter, building from source")
        srcdir = fetch_sdist(tmp)
        use_mingw_when_msvc_is_missing(srcdir)

        result = subprocess.run(
            [
                sys.executable,
                "-m",
                "pip",
                "wheel",
                "--disable-pip-version-check",
                "--no-deps",
                "--wheel-dir",
                str(DEST),
                str(srcdir),
            ]
        )
        if result.returncode != 0:
            print("build-pyyaml: build failed", file=sys.stderr)
            return result.returncode

    wheels = sorted(DEST.glob("pyyaml-*.whl"), key=lambda path: path.stat().st_mtime)
    if wheels:
        print(f"built {wheels[-1]}")
    print(f"wheelhouse: {DEST}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
