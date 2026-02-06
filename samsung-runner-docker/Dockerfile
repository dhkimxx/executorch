FROM ubuntu:22.04

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install basic dependencies
RUN apt-get update && apt-get install -y \
    curl \
    jq \
    sudo \
    git \
    build-essential \
    cmake \
    unzip \
    wget \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Install Python 3.10 and Pip
RUN add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y python3.10 python3.10-dev python3.10-venv python3-pip && \
    ln -s /usr/bin/python3.10 /usr/bin/python

# Install Miniforge (to avoid Anaconda ToS issues)
ENV CONDA_DIR=/opt/conda
RUN wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh -O miniforge.sh && \
    bash miniforge.sh -b -p $CONDA_DIR && \
    rm miniforge.sh
ENV PATH=$CONDA_DIR/bin:$PATH

# Create a Python 3.10 environment called 'executorch' with newer cmake (>=3.29 required by pyproject.toml)
RUN $CONDA_DIR/bin/conda create -y -n executorch python=3.10 pip "cmake>=3.29"

# Set the new environment as default in PATH
ENV PATH=$CONDA_DIR/envs/executorch/bin:$CONDA_DIR/bin:$PATH

# Create a runner user
RUN useradd -m runner && \
    echo "runner ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Create /opt/ndk and give ownership to runner (for setup script)
# Also give ownership of conda directory to allow pip installs
RUN mkdir -p /opt/ndk && \
    chown -R runner:runner /opt/ndk $CONDA_DIR

# Install Android NDK r28c (required by Samsung build)
ENV ANDROID_NDK_VERSION=r28c
ENV ANDROID_NDK_ROOT=/opt/ndk
RUN cd /tmp && \
    wget -q https://ossci-android.s3.amazonaws.com/android-ndk-${ANDROID_NDK_VERSION}-linux.zip && \
    unzip -q android-ndk-${ANDROID_NDK_VERSION}-linux.zip && \
    mv android-ndk-${ANDROID_NDK_VERSION}/* /opt/ndk/ && \
    rm android-ndk-${ANDROID_NDK_VERSION}-linux.zip && \
    rm -rf android-ndk-${ANDROID_NDK_VERSION}

# Switch to runner user
USER runner
WORKDIR /home/runner

# Install GitHub Runner dependencies (optional, mostly covered above)
# Access GitHub Runner download URL - this changes versions, so simplified here.
# User will pass RUNNER_VERSION in env or we default.
ARG RUNNER_VERSION="2.311.0"
RUN curl -o actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && \
    tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && \
    rm actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

# Install runner dependencies
RUN sudo ./bin/installdependencies.sh

COPY entrypoint.sh /home/runner/entrypoint.sh
RUN sudo chmod +x /home/runner/entrypoint.sh

ENTRYPOINT ["/home/runner/entrypoint.sh"]
