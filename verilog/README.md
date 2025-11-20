# Verilator

* https://hackmd.io/@chtsai/S1wLTsQvj
* https://github.com/verilator/verilator/blob/master/ci/docker/run/verilator-wrap.sh
* [VaporView](https://github.com/Lramseyer/vaporview) - Waveform viewer extension for Visual Studio Code

```sh
verilator --cc --main src/adder4.v src/fulladder.v src/testbench.cpp

make -c obj_dir -f Vadder4.mk

# with build
verilator --cc --build --exe src/adder4.v src/fulladder.v src/testbench.cpp
```

# cmake

```sh
cmake -S . -B build -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON && cmake --build build
cmake -E env "PATH=/path/to/add:${PATH}" <command>

# message(DEBUG "...")
cmake -S . -B build --log-level DEBUG

# --debug-output/--trace for cmake internal status
cmake -S . -B build --debug-output
```

# SystemC

```sh
SYSTEMC_VERSION=3.0.1
SYSTEMC_PREFIX=/usr/local/systemc-${SYSTEMC_VERSION}

# download
curl -o /tmp/systemc-${SYSTEMC_VERSION}.tgz -L https://github.com/accellera-official/systemc/archive/refs/tags/${SYSTEMC_VERSION}.tar.gz \
    && tar xzf /tmp/systemc-${SYSTEMC_VERSION}.tgz -C /tmp

# configure (3.0.1 missing `docs/DEVELOPMENT.md`)
mkdir -p /tmp/systemc-${SYSTEMC_VERSION}/build && cd /tmp/systemc-${SYSTEMC_VERSION}/build \
    && touch /tmp/systemc-${SYSTEMC_VERSION}/docs/DEVELOPMENT.md \
    && ../configure --prefix=${SYSTEMC_PREFIX} --with-arch-suffix= \
    && make -j \
    && make install

# cmake
cmake -S /tmp/systemc-${SYSTEMC_VERSION} -B /tmp/systemc-${SYSTEMC_VERSION}/build \
    -DCMAKE_INSTALL_PREFIX=${SYSTEMC_PREFIX} \
    -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON \
    && cmake --build /tmp/systemc-${SYSTEMC_VERSION}/build \
    && cmake --install /tmp/systemc-${SYSTEMC_VERSION}/build
```

# Dev Container

* [dev container - user](https://stackoverflow.com/a/78621662)

Download .vsix

* https://stackoverflow.com/a/79565372

```sh
DEV_CONTAINER_ID=ms-vscode-remote.remote-containers
# TARGET_PLATFORM=win32-x64

# ms-python.python
# https://marketplace.visualstudio.com/_apis/public/gallery/publishers/ms-python/vsextensions/python/2024.17.2024100401/vspackage?targetPlatform=win32-x64

dl_url="https://marketplace.visualstudio.com/_apis/public/gallery/publishers/ms-vscode-remote/vsextensions/remote-containers/0.426.0/vspackage"

curl -Lo devcontainer-0.426.0.vsix "${dl_url}"
```

Dockerfile

```dockerfile
FROM your-image:1.0.0 AS base

# ... the final image instructions (WORKDIR, CMD, etc)

# DevContainer

FROM base AS devcontainer

ARG REMOTE_USER
ARG REMOTE_UID
ARG REMOTE_GID
RUN <<EOF
    addgroup --gid ${REMOTE_GID} ${REMOTE_USER}
    adduser --disabled-password --uid ${REMOTE_UID} --gid ${REMOTE_GID} ${REMOTE_USER}
EOF

ENV HOME /home/${REMOTE_USER}
# HEALTHCHECK NONE

USER ${REMOTE_USER}
```

devcontainer.json

```json
{
    "build": {
        "dockerfile": "../Dockerfile",
        "args": {
            "REMOTE_USER": "${localEnv:USER}",
            "REMOTE_UID": "${localEnv:REMOTE_UID:1000}",
            "REMOTE_GID": "${localEnv:REMOTE_GID:1000}"
        },
        "target": "devcontainer",
        "context": ".."
    },
    "remoteUser": "${localEnv:USER}",
    "customizations": {
        ...
    }
}
```
