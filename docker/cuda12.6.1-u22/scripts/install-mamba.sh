#!/bin/bash
set -e

# Default installation directory for Miniconda
DEFAULT_INSTALL_DIR="/opt/conda"
INSTALL_DIR="${1:-$DEFAULT_INSTALL_DIR}"  # Use the first argument or default to /opt/conda
DEFAULT_MINICONDA_VERSION="latest"
MINICONDA_VERSION="${2:-$DEFAULT_MINICONDA_VERSION}"  # Use the second argument or default to latest

# Function to log messages
log() {
    echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*"
}

# Function to download Miniconda
download_miniconda() {
    log "Downloading Miniconda installer..."

    # test "${TARGETARCH}" = 'amd64' && export ARCH='x86_64'
    # test "${TARGETARCH}" = 'arm64' && export ARCH='aarch64'
    # test "${TARGETARCH}" = 'ppc64le' && export ARCH='ppc64le'
    export ARCH='x86_64'
    MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-${ARCH}.sh"
    log " ... from $MINICONDA_URL"
    curl -L $MINICONDA_URL -o ~/miniconda.sh

    if [[ ! -f ~/miniconda.sh ]]; then
        log "Error: Failed to download Miniconda installer."
        exit 1
    fi
}

# Function to install Miniconda
install_miniconda() {

    log "Installing Miniconda..."
    if [[ ! -f ~/miniconda.sh ]]; then
        log "Error: No Miniconda installer found."
        exit 1
    fi

    log "Installing Miniconda to $INSTALL_DIR..."
    /bin/bash ~/miniconda.sh -b -p "$INSTALL_DIR"
    if [[ $? -ne 0 ]]; then
        log "Error: Miniconda installation failed."
        exit 1
    fi

    log "Initialize bash shell for Conda"
    cat << EOF > "${INSTALL_DIR}/init-conda.sh"
# Initialize shell for Conda
__conda_setup="\$(${INSTALL_DIR}/bin/conda shell.bash hook 2> /dev/null || true)"
if [ -n "\${__conda_setup}" ]; then
    echo "  Initialize Conda env"
    eval "\$__conda_setup"
else
    echo "  ERROR initializing Conda env"
fi
unset __conda_setup
EOF

    # Test source file
    source $INSTALL_DIR/init-conda.sh
    if [[ $? -ne 0 ]]; then
        log "Error: Failed to initialize the environment for Conda."
        exit 1
    fi

    log "Cleaning up installer script..."
    rm ~/miniconda.sh

    log "Cleaning up unused packages and caches..."
    $INSTALL_DIR/bin/conda clean --all -fy

    log "Conda installed and initialized successfully."
}

# Function to install mamba
install_mamba() {
    log "Installing mamba package manager..."
    conda install -n base -c conda-forge mamba -y --quiet 
    if [[ $? -ne 0 ]]; then
        log "Error: Failed to install mamba."
        exit 1
    fi

    log "Initialize shell for Mamba"
    cat << EOF > "${INSTALL_DIR}/init-mamba.sh"
# Initialize shell for Mamba
__mamba_setup="\$(mamba shell hook --shell bash 2> /dev/null || true)" 
if [ -n "\${__mamba_setup}" ]; then
    echo "  Initialize Mamba env"
    eval "\$__mamba_setup"
else
    echo "  ERROR initializing Mamba env"
fi
unset __mamba_setup
EOF

    # Test source file
    source $INSTALL_DIR/init-mamba.sh
    if [[ $? -ne 0 ]]; then
        log "Error: Failed to initialize the environment for Mamba."
        exit 1
    fi

    log "Cleaning up unused packages and caches..."
    conda clean --all -fy

    log "Mamba installed and initialized successfully."
}


# Function to configure conda channels
configure_conda_channels() {
    log "Configuring conda channels at system level..."
    conda config --system --set show_channel_urls yes || true
    conda config --system --set channel_priority flexible || true
    conda config --system --remove-key channels || true
    conda config --system --add channels defaults || true
    conda config --system --prepend channels conda-forge || true
    conda config --system --remove channels defaults || true
    conda config --system --append channels nodefaults || true

    log "Configuring conda channels at user level..."
    conda config --set show_channel_urls yes || true
    conda config --set channel_priority flexible || true
    conda config --remove-key channels || true
    conda config --add channels defaults || true
    conda config --prepend channels conda-forge || true
    conda config --remove channels defaults || true
    conda config --append channels nodefaults || true
}


# Function to check if Conda is installed
check_conda_installed() {
    if command -v conda &> /dev/null; then
        echo "Conda is installed."
        return 0
    else
        echo "Conda is not installed."
        return 1
    fi
}

# Function to check if a Conda environment is activated
check_conda_env_activated() {
    if [[ -n "$CONDA_DEFAULT_ENV" ]]; then
        echo "Conda environment '$CONDA_DEFAULT_ENV' is activated."
        return 0
    else
        echo "No Conda environment is activated."
        return 1
    fi
}

# Function to check if Mamba is installed
check_mamba_installed() {
    if command -v mamba &> /dev/null; then
        echo "Mamba is installed."
        return 0
    else
        echo "Mamba is not installed."
        return 1
    fi
}




# Main script execution
log "Starting script execution..."
# Install Miniconda
download_miniconda
install_miniconda
source $INSTALL_DIR/init-conda.sh
# Install Mamba
install_mamba
source $INSTALL_DIR/init-mamba.sh
# Configure conda channels
configure_conda_channels
# Create init files tt replace init-conda.sh and init-mamba.sh
log "Mamba installation completed successfully."
