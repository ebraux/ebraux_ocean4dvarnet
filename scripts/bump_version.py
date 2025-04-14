"""
This script updates the version number in the pyproject.toml file.
Usage: bump_version.py vX.Y.Z
"""

import sys
import tomllib
import tomli_w

if len(sys.argv) != 2 or not sys.argv[1].startswith("v"):
    print("Usage: bump_version.py vX.Y.Z")
    sys.exit(1)

new_version = sys.argv[1][1:]

with open("pyproject.toml", "rb") as f:
    data = tomllib.load(f)

data["project"]["version"] = new_version

with open("pyproject.toml", "wb") as f:
    f.write(tomli_w.dumps(data).encode())

print(f"✅ pyproject.toml updated to version {new_version}")
