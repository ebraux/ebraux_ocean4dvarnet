#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status

# Source the Conda/Mamba environment
if [ -f "$MAMBA_DIR/init.sh" ]; then
    source "$MAMBA_DIR/init.sh"
    conda activate $MAMBA_ENV_NAME
else
    echo "Error: Conda/Mamba environment not found. Ensure Miniconda is installed correctly."
    exit 1
fi

# Execute the provided command
exec "$@"