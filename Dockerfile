FROM asia-docker.pkg.dev/colab-images/public/runtime:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV HF_HOME=/content/hf_cache
ENV MAX_JOBS=4
ENV TORCH_CUDA_ARCH_LIST=8.6
ENV _GLIBCXX_USE_CXX11_ABI=1

RUN apt-get update && apt-get install -y --no-install-recommends build-essential cmake ninja-build git curl && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir --upgrade pip

# --- UPDATED TO CU126 ---
RUN pip install --no-cache-dir torch==2.6.0 torchvision==0.21.0 torchaudio==2.6.0 --index-url https://download.pytorch.org/whl/cu126

# --- FIXED LINE (Server is still down, so we skip the broken extensions) ---
RUN pip install --no-cache-dir torch-geometric

# ALTERNATIVE 1 (Legacy URL - updated to cu126):
# RUN pip install --no-cache-dir torch-cluster torch-scatter torch-sparse -f https://pytorch-geometric.com/whl/torch-2.6.0+cu126.html

# ALTERNATIVE 2 (Build from Source - slow, requires CUDA toolkit):
# RUN pip install --no-cache-dir torch-cluster torch-scatter torch-sparse --no-build-isolation
# ------------------

RUN pip install --no-cache-dir trimesh fast_simplification embreex scikit-image einops omegaconf transformers diffusers accelerate safetensors huggingface_hub pyyaml scipy tqdm objaverse opencv-python

RUN pip install --no-cache-dir git+https://github.com/ashawkey/cubvh --no-build-isolation || true

RUN rm -rf /root/.cache/pip /tmp/*
