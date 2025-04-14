# Variables
VERSION ?= $(error "Please provide the version with VERSION=1.2.3 (e.g., make release VERSION==1.2.3)")
TAG = v$(VERSION)
PYPROJECT = pyproject.toml

# Location of the version bump script
BUMP_SCRIPT = scripts/bump_version.py

.PHONY: bump commit tag push release check

## Update pyproject.toml version
bump:
	@echo "Updating $(PYPROJECT) to version $(VERSION)"
	python $(BUMP_SCRIPT) v$(VERSION)

## Commit the updated version
commit:
	@git add $(PYPROJECT)
	@git commit -m "release: version $(VERSION)"

## Create a Git tag
tag:
	@git tag v$(VERSION)

## Push branch and tag to remote
push:
	@git push origin HEAD
	@git push origin v$(VERSION)

## Check the current version in pyproject.toml
check:
	@echo "Checking version in $(PYPROJECT)"
	@grep '^version =' $(PYPROJECT)

## Run full release workflow: bump, check, commit, tag, push
release: bump check commit tag push
	@echo "Release v$(VERSION) completed."
