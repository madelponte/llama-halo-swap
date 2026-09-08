# llama.cpp -> /install
ARG BUILDER_BASE
FROM ${BUILDER_BASE} AS build

ARG BACKEND=cuda
ARG LLAMA_COMMIT_HASH=master
ARG LLAMA_REPO=https://github.com/ggml-org/llama.cpp.git
COPY install-llama.sh /build/
RUN --mount=type=cache,id=ccache-${BACKEND},target=/ccache \
    --mount=type=cache,id=llama-${BACKEND},target=/src/llama.cpp/build \
    LLAMA_REPO=${LLAMA_REPO} BACKEND=${BACKEND} \
    bash /build/install-llama.sh "${LLAMA_COMMIT_HASH}"

FROM scratch
COPY --from=build /install /install
