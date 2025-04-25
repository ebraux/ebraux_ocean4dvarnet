#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status

# Source the Conda environment
if [ -f "$HOME/conda/etc/profile.d/conda.sh" ]; then
    source "$HOME/conda/etc/profile.d/conda.sh"
    conda activate oceanenv
else
    echo "Error: Conda environment not found. Ensure Miniconda is installed correctly."
    exit 1
fi

# Execute the provided command
exec "$@"