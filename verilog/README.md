# Verilator

* https://hackmd.io/@chtsai/S1wLTsQvj
* https://github.com/verilator/verilator/blob/master/ci/docker/run/verilator-wrap.sh

```sh
verilator --cc --main src/adder4.v src/fulladder.v src/testbench.cpp

make -c obj_dir -f Vadder4.mk

# with build
verilator --cc --build --exe src/adder4.v src/fulladder.v src/testbench.cpp
```

# Dev Container

* [dev container - user](https://stackoverflow.com/a/78621662)

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