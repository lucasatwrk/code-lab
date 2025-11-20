FROM verilator/verilator:v5.040 AS build
ARG SYSTEMC_VERSION=3.0.1
ENV SYSTEMC_ROOT=/usr/local/systemc-${SYSTEMC_VERSION}
ENV VERILATOR_ROOT=/usr/local/share/verilator

RUN apt update && apt install -y curl cmake ninja-build && apt clean && rm -rf /var/lib/apt/lists/* \
    && curl -o /tmp/systemc-${SYSTEMC_VERSION}.tgz -L https://github.com/accellera-official/systemc/archive/refs/tags/${SYSTEMC_VERSION}.tar.gz \
    && tar xzf /tmp/systemc-${SYSTEMC_VERSION}.tgz -C /tmp \
    && cmake -S /tmp/systemc-${SYSTEMC_VERSION} -B /tmp/systemc-${SYSTEMC_VERSION}/build \
        -DCMAKE_INSTALL_PREFIX=${SYSTEMC_ROOT} \
        -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON \
        -DDISABLE_COPYRIGHT_MESSAGE:BOOL=ON \
    && cmake --build /tmp/systemc-${SYSTEMC_VERSION}/build \
    && cmake --install /tmp/systemc-${SYSTEMC_VERSION}/build \
    && rm -rf /tmp/systemc-${SYSTEMC_VERSION}*
