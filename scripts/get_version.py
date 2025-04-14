# scripts/extract_version.py
import tomllib
import sys

def main():
    with open("pyproject.toml", "rb") as f:
        data = tomllib.load(f)
        version = data["project"]["version"]
        print(version)

if __name__ == "__main__":
    main()
