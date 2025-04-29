#!/bin/bash


create_activate_file() {
    local env_name=$1
    local mamba_base_dir=$2
    local activate_file="$mamba_base_dir/activate-${env_name}.sh"
    
    echo "Creating activation file..."
    cat << EOF > "${activate_file}"
# This script should never be called directly, only sourced:
#     source ${activate_file}

# shellcheck shell=bash

if [ -z "\$CONDA_DEFAULT_ENV" ] || [ "\$CONDA_DEFAULT_ENV" != "${mamba_base_dir}" ]; then
    source ${mamba_base_dir}/init-conda.sh
    source ${mamba_base_dir}/init-mamba.sh
    mamba activate ${env_name}
else 
    echo "Conda/Mamba already configured. Skipping initialization."
fi   

EOF

    if [[ ! -f $activate_file ]]; then
        echo "Error: creating ${activate_file}."
        exit 1
    else
        echo "Init file ${activate_file} created successfully."
    fi
}


# Check if the requirements file and environment name are provided
if [[ -z "$1" || -z "$2" ]]; then
    echo "Usage: $0 <environment_name> <MAMBA_BASE_DIR>" 
    exit 1
fi

create_activate_file "$1" "$2"