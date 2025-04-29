#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status

# Source the Conda/Mamba environment
if [ -f "$MAMBA_DIR/activate-${MAMBA_ENV_NAME}.sh" ]; then
    echo "Init Conda/Mamba and activate environment ${MAMBA_ENV_NAME}"
    source "$MAMBA_DIR/activate-${MAMBA_ENV_NAME}.sh"
else
    echo "Error: Mamba environment not found. Ensure Mamba is installed correctly."
    exit 1
fi

# Execute the provided command
exec "$@"