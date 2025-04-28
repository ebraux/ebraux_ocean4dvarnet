# Use a base image with CUDA runtime
ARG BASE_IMAGE=nvidia/cuda:12.6.1-runtime-ubuntu22.04
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
WORKDIR ${WORKSPACE_DIR}

# Copy system scripts
COPY --chmod=755 scripts/ /opt/

# Install system dependencies
RUN /opt/install-system-libs.sh && \
    # Generate locales
    /opt/config-locales.sh && \
    # Fix user permissions
    /opt/fix-user-permissions.sh  && \
    # # Clean
    /opt/clean.sh

USER ${UID}


# Set Home_dir for conda/mamba
ENV MAMBA_DIR=$HOME/mamba
ENV MAMBA_ENV_NAME=oceanenv


# Create a conda environment and install dependencies
RUN git clone --branch main --single-branch --depth 1 https://github.com/CIA-Oceanix/ocean4dvarnet.git  ocean4dvarnet && \
    # Copy the scripts folder to the container
    mv ocean4dvarnet/scripts $HOME/scripts && \
    chmod 755 $HOME/scripts/* && \
    # Install Mamba
    /opt/install-mamba.sh $MAMBA_DIR && \
    # Initialize Mamba
    source $MAMBA_DIR/init.sh && \
    # Create a oceanenv Mamba environment, and install the dependencies
    /opt/setup_mamba_env.sh $MAMBA_ENV_NAME ocean4dvarnet/environment.yaml && \
    # mamba create -n oceanenv python=3.12 -y && \
    # # Activate the Mamba environment
    # mamba activate oceanenv && \
    # # Configure conda channels for the environment
    # conda config --env --set show_channel_urls yes || true && \
    # conda config --env --set channel_priority flexible || true && \
    # conda config --env --remove-key channels || true && \
    # conda config --env --add channels  defaults || true && \
    # conda config --env --prepend channels conda-forge || true && \
    # conda config --env --remove channels  defaults || true && \
    # conda config --env --append channels  nodefaults || true && \
    # # Install dependencies from the list in the repository
    # mamba env update -y -f ocean4dvarnet/environment.yaml -y --quiet&& \
    # mamba clean --all -y && \
    # Clean up
    mamba clean --all -y && \
    # remove installation files
    #rm -f scripts/install-mamba.sh && \
    # Remove the cloned repository
    rm -rf ocean4dvarnet


# # Copy the entrypoint script to the container
# COPY --chmod=+x entrypoint.sh /usr/local/bin/entrypoint.sh

# # Set the entrypoint to the script
# ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# USER ${UID}
