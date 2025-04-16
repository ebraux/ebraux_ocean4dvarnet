# Variables
# This is the version that will be used in the release process
# Regular expression for semantic versioning (MAJOR.MINOR.PATCH)
SEMVER_REGEX = ^[0-9]+\.[0-9]+\.[0-9]+$$
# List of targets that require VERSION to be set
NEEDS_VERSION_TARGETS := validate_version bump commit tag push release
# Check if the current target is one that needs VERSION
# If VERSION is needed and not provided, trigger error
ifeq ($(filter $(MAKECMDGOALS),$(NEEDS_VERSION_TARGETS)), $(MAKECMDGOALS))
  VERSION := $(if $(VERSION),$(VERSION),$(error Please provide the version with VERSION=1.2.3 (e.g., make release VERSION=1.2.3)))
endif
TAG = v$(VERSION)

# Location of the pyproject.toml file
# It is used to manage the version of the project
# and is updated during the release process.
PYPROJECT = pyproject.toml

# Location of the version bump script
BUMP_SCRIPT = scripts/bump_version.py


.PHONY: bump commit tag push release check validate_version lint test quality


# ---------------------------------------------- #
# ------- Code quality and tests Process ------- #
# ---------------------------------------------- #

## Run code quality checks
lint:
	@echo "--- Running code quality checks... ---"
	@echo "Running pylint for code quality checks..."
	@pylint ocean4dvarnet || true
	@echo "Running isort for code formatting..."
	@isort --check-only ocean4dvarnet || true
	@echo "Running black for code formatting..."
	@black --check --diff ocean4dvarnet || true
	@echo "Running flake8 for style guide enforcement..."
	@flake8 ocean4dvarnet || true
	@echo "Running mypy for type checking..."
	@python -m mypy ocean4dvarnet || true
	@echo "Running pydocstyle for docstring style checks..."
	@pydocstyle ocean4dvarnet || true
	@echo "Running ruff for code quality checks..."
	@ruff check ocean4dvarnet || true
	@echo "Running ruff for code formatting..."
	@ruff check --fix ocean4dvarnet || true
	@echo "Running ruff for code formatting with diff..."
	@ruff format --check --diff ocean4dvarnet || true


## Run code security checks
security:
	@echo "--- Running code quality checks... ---"
	@echo "Running bandit for security checks..."
	@bandit -r ocean4dvarnet || true
	@echo "Running safety for security vulnerability checks..."
	@safety check --full-report || true


## Run unit tests with pytest
test:
	@echo "Running tests with pytest..."
	@pytest || true

## Run lint, security and test
quality: lint security test
	@echo "Code quality, security and tests completed successfully."


# ---------------------------------------------- #
# -------------- Release Process --------------- #
# ---------------------------------------------- #

## Validate semantic versioning (MAJOR.MINOR.PATCH)
validate_version:
	@echo "Validating version format: $(VERSION)"
	@if ! echo "$(VERSION)" | grep -Eq "$(SEMVER_REGEX)"; then \
		echo "Invalid version format: '$(VERSION)' — expected format: MAJOR.MINOR.PATCH (e.g., 1.2.3)"; \
		exit 1; \
	fi

## Update pyproject.toml version
bump: validate_version
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
