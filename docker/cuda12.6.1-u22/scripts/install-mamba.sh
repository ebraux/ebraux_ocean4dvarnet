#!/bin/bash
set -e

# Default installation directory for Miniconda
DEFAULT_INSTALL_DIR="/opt/conda"
INSTALL_DIR="${1:-$DEFAULT_INSTALL_DIR}"  # Use the first argument or default to /opt


# Function to log messages
log() {
    echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*"
}

# Function to download and install Miniconda
install_miniconda() {
    log "Downloading Miniconda installer..."
    wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh

    if [[ ! -f ~/miniconda.sh ]]; then
        log "Error: Failed to download Miniconda installer."
        exit 1
    fi

    log "Installing Miniconda to $INSTALL_DIR..."
    /bin/bash ~/miniconda.sh -b -p "$INSTALL_DIR"
    if [[ $? -ne 0 ]]; then
        log "Error: Miniconda installation failed."
        exit 1
    fi

    log "Initialize bash shell for Conda"
    echo '# Initialize shell for Conda' >> $INSTALL_DIR/init.sh
    echo "eval \"\$(${INSTALL_DIR}/bin/conda shell.bash hook)\"" >> ${INSTALL_DIR}/init-conda.sh
    #eval "$(/opt/conda/bin/conda shell.bash hook)"
    if [[ $? -ne 0 ]]; then
        log "Error: Failed to initialize bash shell for conda."
        exit 1
    fi

    # log "Setting up conda environment..."
    # # Create a temporary file with the necessary parts of ~/.bashrc
    # temp_bashrc=$(mktemp)
    # sed '/^# If not running interactively/,/^esac/d' ~/.bashrc > "$temp_bashrc"
    # # Source the temporary file
    # source "$temp_bashrc"
    source $INSTALL_DIR/init-conda.sh
    if [[ $? -ne 0 ]]; then
        log "Error: Failed to initialize the environment for Conda."
        exit 1
    fi
    log " --------- in the function install_conda PATH = $PATH"

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
    echo '# Initialize shell for Mamba' >> $INSTALL_DIR/init.sh
    echo "eval \"\$(mamba shell hook --shell bash)\"" >> $INSTALL_DIR/init-mamba.sh
    if [[ $? -ne 0 ]]; then
        log "Error: Failed to initialize shell for mamba."
        exit 1
    fi

    source $INSTALL_DIR/init.sh
    if [[ $? -ne 0 ]]; then
        log "Error: Failed to initialize the environment for Conda."
        exit 1
    fi
    log " --------- in the function install_mamba PATH = $PATH"



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

create_init_files() {
    log "Creating init files..."
    echo '#!/bin/bash' > $INSTALL_DIR/init.sh
    echo 'set -e' >>  $INSTALL_DIR/init.sh
    echo '' >>  $INSTALL_DIR/init.sh
    echo '# --- Setting up Conda ---' >> $INSTALL_DIR/init.sh
    cat $INSTALL_DIR/init-conda.sh >> $INSTALL_DIR/init.sh
    echo '' >>  $INSTALL_DIR/init.sh
    echo '# --- Setting up Mamba ---' >> $INSTALL_DIR/init.sh
    cat $INSTALL_DIR/init-mamba.sh >> $INSTALL_DIR/init.sh
}

setup_bashrc() {
    log "Setting up ~/.bashrc..."
    if ! grep -q "Setting up Mamba" ~/.bashrc; then
        echo "# --- Setting up Mamba ---" >> ~/.bashrc
    fi

    if ! grep -q "source $INSTALL_DIR/init.sh" ~/.bashrc; then
        echo "source $INSTALL_DIR/init.sh" >> ~/.bashrc
    fi

    log "Bashrc setup completed."
}

# Main script execution
log "Starting script execution..."
# Install Miniconda
install_miniconda
source $INSTALL_DIR/init-conda.sh
# Install Mamba
install_mamba
source $INSTALL_DIR/init-mamba.sh
# Configure conda channels
configure_conda_channels
# Create init files tt replace init-conda.sh and init-mamba.sh
create_init_files
rm -f $INSTALL_DIR/init-conda.sh
rm -f $INSTALL_DIR/init-mamba.sh
# Initialyse Mamba for Bash, in  ~/.bashrc
setup_bashrc
log "Mamba installation completed successfully."



