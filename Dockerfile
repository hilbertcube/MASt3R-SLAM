FROM nvidia/cuda:12.1.0-devel-ubuntu22.04

ENV CUDA_HOME=/usr/local/cuda
ENV PATH="$CUDA_HOME/bin:$PATH"
ENV LD_LIBRARY_PATH="$CUDA_HOME/lib64:$LD_LIBRARY_PATH"

# Install system dependencies
RUN apt-get update && apt-get install -y \
    wget curl git build-essential \
    libgl1-mesa-glx libglib2.0-0 libgomp1 \
    && rm -rf /var/lib/apt/lists/*

# Install Miniconda
RUN wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/conda \
    && rm Miniconda3-latest-Linux-x86_64.sh

RUN apt-get update && apt-get install -y libusb-1.0-0-dev

# Setup environment
ENV PATH="/opt/conda/bin:$PATH"
WORKDIR /app

# Accept Anaconda Terms of Service for default channels
RUN conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main
RUN conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r

# Copy and install dependencies
COPY . .
RUN conda create -y -n mast3r-slam python=3.11
ENV PATH="/opt/conda/envs/mast3r-slam/bin:$PATH"

# Install PyTorch with CUDA 12.1 support
RUN pip install torch==2.1.2 torchvision==0.16.2 torchaudio==2.1.2 --index-url https://download.pytorch.org/whl/cu121

# Set CUDA arch for RTX 4070
ENV TORCH_CUDA_ARCH_LIST="8.9"

# Install curope first (with no build isolation)
RUN pip install --no-build-isolation thirdparty/mast3r/dust3r/croco/models/curope

# Install mast3r and in3d in editable mode
RUN pip install -e thirdparty/mast3r
RUN pip install -e thirdparty/in3d

RUN ls -l /usr/local/cuda/bin/nvcc

# Install main repo
RUN pip install --no-build-isolation -e .
