#!/bin/bash

# Function to check if required binaries are available
check_binaries() {
    if ! command -v conda &> /dev/null; then
        echo "Error: 'conda' binary is not available. Please ensure Conda is installed."
        exit 1
    fi

    if ! command -v mamba &> /dev/null; then
        echo "Error: 'mamba' binary is not available. Please ensure Mamba is installed."
        exit 1
    fi
}

# Function to create and configure the Mamba environment
create_and_configure_mamba_env() {
    local env_name=$1
    local requirements_file=$2

    # Create a Mamba environment
    mamba create -n "$env_name" python=3.12 -y
    # Check if the environment was created successfully
    if [[ $? -ne 0 ]]; then
        echo "Error: Failed to create the Mamba environment."
        exit 1
    fi

    # Activate the Mamba environment
    source activate "$env_name"

    # Configure conda channels for the environment
    conda config --env --set show_channel_urls yes || true
    conda config --env --set channel_priority flexible || true
    conda config --env --remove-key channels || true
    conda config --env --add channels defaults || true
    conda config --env --prepend channels conda-forge || true
    conda config --env --remove channels defaults || true
    conda config --env --append channels nodefaults || true

    # Install dependencies from the list in the repository
    mamba env update -y -f "$requirements_file" --quiet
    # Check if the dependencies were installed successfully
    if [[ $? -ne 0 ]]; then
        echo "Error: Failed to install dependencies in the Mamba environment."
        exit 1
    fi
}

# Check if the requirements file and environment name are provided
if [[ -z "$1" || -z "$2" ]]; then
    echo "Usage: $0 <environment_name> <requirements_file>" 
    exit 1
fi

# Check if required binaries are available
check_binaries

# Call the function with the environment name and requirements file as arguments
create_and_configure_mamba_env "$1" "$2"