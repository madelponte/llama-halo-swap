# Strix Halo container

This fork publishes only the amd64 Vulkan unified image:

```text
ghcr.io/madelponte/llama-halo-swap:unified-vulkan
```

It is based on llama-swap's upstream `unified-vulkan` image, but its
`llama-server`, `llama-cli`, `llama-tts`, and `llama-bench` binaries are built
from the latest `master` commit of
[`halo-box/strix-llama.cpp`](https://github.com/halo-box/strix-llama.cpp).
The other GPU-capable unified-image tools (whisper.cpp,
stable-diffusion.cpp, audio.cpp, and llama-swap) remain included. ik_llama.cpp
is intentionally omitted because this image targets Strix Halo Vulkan
inference; skipping its CPU-oriented build saves CI time and registry space.

The scheduled workflow resolves every moving ref to a commit before building,
then publishes the image and its date-qualified tag. `/versions.txt` in the
image records both the strix-llama.cpp repository and exact commit.

CUDA variants are hard-disabled in `.github/workflows/unified-docker.yml`. The
legacy workflow in `.github/workflows/containers.yml` is also skipped outside
the upstream `mostlygeek/llama-swap` repository. This avoids paying to build or
store images this fork does not use while retaining upstream workflow structure
to reduce merge conflicts.

## Build locally

The shared unified build script still defaults to upstream llama.cpp so it
remains reusable after upstream syncs. Select the Strix Halo source explicitly:

```bash
LLAMA_REPO=https://github.com/halo-box/strix-llama.cpp.git \
INCLUDE_IK_LLAMA=false \
  ./docker/unified/build-image.sh --vulkan
```

The resulting local image is `llama-swap:unified-vulkan`. Vulkan does not use a
compile-time `gfx1151` target (unlike ROCm/HIP); the Strix Halo optimizations are
provided by the fork's Vulkan sources and selected for the GPU/driver at
runtime.

## Registry retention

`.github/workflows/strix-halo-container-cleanup.yml` runs every Sunday and
removes images older than 60 days from both the published image package and the
content-addressed build-artifact package. The moving `unified-vulkan`, rootless,
and amd64 tags are always preserved. A manual run defaults to dry-run mode so
its deletion plan can be reviewed first; scheduled runs perform the cleanup.
