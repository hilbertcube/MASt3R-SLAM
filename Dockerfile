# Use NVIDIA CUDA base image with Ubuntu 22.04
FROM nvidia/cuda:12.4.0-devel-ubuntu22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV CUDA_HOME=/usr/local/cuda

# Install system dependencies
RUN apt-get update && apt-get install -y \
    python3.11 \
    python3.11-dev \
    python3-pip \
    git \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Set Python 3.11 as default
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.11 1
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1

# Upgrade pip
RUN python -m pip install --upgrade pip

# Set working directory
WORKDIR /workspace

# Copy project files
COPY . /workspace/

# Install PyTorch with CUDA 12.4
RUN pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124

# Install MASt3R
RUN pip install --no-build-isolation -e thirdparty/mast3r

# Set entrypoint
CMD ["/bin/bash"]