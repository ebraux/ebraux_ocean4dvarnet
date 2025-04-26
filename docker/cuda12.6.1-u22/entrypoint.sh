#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status

# Source the Conda environment
if [ -f "$MAMBA_DIR/init_mamba.sh" ]; then
    source "$MAMBA_DIR/init_mamba.sh"
    conda activate $MAMBA_ENV_NAME
else
    echo "Error: Conda environment not found. Ensure Miniconda is installed correctly."
    exit 1
fi

# Execute the provided command
exec "$@"