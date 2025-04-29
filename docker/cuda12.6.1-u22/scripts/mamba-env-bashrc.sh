#!/bin/bash

setup_bashrc() {
    local env_name=$1
    local mamba_base_dir=$2
    local activate_file="$mamba_base_dir/activate-${env_name}.sh"

    echo "Setting up ~/.bashrc..."
    
    if ! grep -q "Setting up Mamba" ~/.bashrc; then
        echo '' >> ~/.bashrc
        echo "# --- Setting up Mamba ---" >> ~/.bashrc
    fi

    if ! grep -q "source ${activate_file}" ~/.bashrc; then
        echo "source ${activate_file}" >> ~/.bashrc
    fi
    
    echo "Bashrc setup completed."
}


# Check if the requirements file and environment name are provided
if [[ -z "$1" || -z "$2" ]]; then
    echo "Usage: $0 <environment_name> <MAMBA_BASE_DIR>" 
    exit 1
fi

setup_bashrc "$1" "$2"