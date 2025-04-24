# Use a base image with CUDA runtime
ARG BASE_IMAGE=nvidia/cuda:12.6.1-runtime-ubuntu22.04
FROM $BASE_IMAGE

# Labels for maintenance and metadata
LABEL maintainer="Emmanuel braux <emmanuel.braux@example.com>"
LABEL description="Docker Image for ocean4dvarnet"
LABEL version="1.0"
LABEL org.opencontainers.image.authors="Emmanuel braux"
LABEL org.opencontainers.image.documentation="https://cia-oceanix.github.io/ocean4dvarnet/"


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

# Install system dependencies and Miniconda
RUN apt-get update && apt-get install -y --no-cache wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender-dev git && \
    wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean --all -fy && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV PATH=/opt/conda/bin:$PATH

# Configure conda
RUN conda config --set channel_priority flexible && \
    conda config --remove-key channels && \
    conda config --add channels  defaults && \
    conda config --prepend channels conda-forge && \
    conda config --remove channels  defaults && \
    conda config --append channels  nodefaults
    
# Update conda and install mamba
RUN conda install -n base -c conda-forge mamba -y && \
    conda clean --all -fy

# Create a conda environment and install dependencies
RUN mamba create -n oceanenv python=3.12 -y && \
    echo "source activate oceanenv" > ~/.bashrc

ENV PATH=/opt/conda/envs/oceanenv/bin:$PATH

# Install dependencies from the list in the repository
RUN git clone https://github.com/ebraux/ebraux_ocean4dvarnet.git  ocean4dvarnet && \
    cp ocean4dvarnet/environment.yaml . && \
    #git checkout 0.1.0 && \
    #cd .. && \
    #rm -rf ocean4dvarnet/.git
    rm -rf ocean4dvarnet && \
    mamba env update -y -f environment.yaml && \
    mamba clean --all -y && \
    rm -rf environment.yaml

# Set locales
ENV LC_ALL="en_US.UTF-8"
ENV LANG="en_US.UTF-8"

USER 1000
