# Use a base image with CUDA runtime
ARG BASE_IMAGE=nvidia/cuda:12.4.1-runtime-ubuntu22.04
FROM $BASE_IMAGE

# Labels for maintenance and metadata
LABEL maintainer="Emmanuel braux <emmanuel.braux@example.com>"
LABEL description="Docker Image for ocean4dvarnet"
LABEL version="1.0"
LABEL org.opencontainers.image.description="Ocean4DVarnet environment"
LABEL org.opencontainers.image.authors="Emmanuel braux"
LABEL org.opencontainers.image.documentation="https://cia-oceanix.github.io/ocean4dvarnet/"
LABEL org.opencontainers.image.source="https://github.com/CIA-Oceanix/ocean4dvarnet"
LABEL org.opencontainers.image.licenses=CeCILL-C


USER root

# System configuration
SHELL ["/bin/bash", "-c"]
ENV SHELL="/bin/bash"
ENV DEBIAN_FRONTEND="noninteractive"

# User configuration
ENV USERNAME="ocean4dvarnet"
ENV UID="1000"  
ENV GROUPNAME="users"
ENV GID="100"
ENV HOME="/home/${USERNAME}"
ENV WORKSPACE_DIR="${HOME}/work"
RUN groupmod -g ${GID} ${GROUPNAME} && \
    # Setup custom user with sudo rights
    useradd ${USERNAME} --uid=${UID} -g ${GROUPNAME} --groups sudo -r --no-log-init --create-home && \
    # Create workspace
    mkdir -p ${WORKSPACE_DIR} && \
    # Disable default sudo message when opening shell
    touch ${HOME}/.sudo_as_admin_successful


# Copy system scripts
COPY --chmod=755 scripts/ /opt/install-scripts

# Install system dependencies
RUN /opt/install-scripts/install-system-libs.sh && \
    # Generate locales
    /opt/install-scripts/config-locales.sh && \
    # Fix user permissions
    /opt/install-scripts/fix-user-permissions.sh  && \
    # # Clean
    /opt/install-scripts/clean.sh

# System prep is finished, now Work as user    
USER ${UID}
WORKDIR ${WORKSPACE_DIR}

# Set Home_dir for conda/mamba
ENV MAMBA_DIR=$HOME/mamba
ENV MAMBA_ENV_NAME=oceanenv


# Create a conda environment and install dependencies
RUN git clone --branch main --single-branch --depth 1 https://github.com/CIA-Oceanix/ocean4dvarnet.git  ocean4dvarnet && \
    # --- Create a conda environment and install dependencies --
    #    - Install Mamba
    /opt/install-scripts/install-mamba.sh $MAMBA_DIR && \
    #    - Initialize Mamba
    source $MAMBA_DIR/init-conda.sh && \
    source $MAMBA_DIR/init-mamba.sh && \
    #    - Create a oceanenv Mamba environment, and install the dependencies
    /opt/install-scripts/mamba-env-setup.sh $MAMBA_ENV_NAME ocean4dvarnet/environment.yaml && \
    #    - Create activation file for enable mamba and activate the environment
    /opt/install-scripts/mamba-env-activate-file.sh $MAMBA_ENV_NAME $MAMBA_DIR && \
    #    - Update ~/.bashrc to activate environment on shell startup
    /opt/install-scripts/mamba-env-bashrc.sh $MAMBA_ENV_NAME $MAMBA_DIR && \
    # --- Copy the scripts folder to the container ---
    mv ocean4dvarnet/scripts $HOME/scripts && \
    chmod 755 $HOME/scripts/* && \
    # --- Clean up ---
    mamba clean --all -y && \
    rm -rf ocean4dvarnet
    
# # Copy the entrypoint script to the container
# COPY --chmod=755 entrypoint.sh /usr/local/bin/entrypoint.sh

# # Set the entrypoint to the script
# ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

USER ${UID}
