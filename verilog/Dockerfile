FROM verilator/verilator:latest AS build
ARG SYSTEMC_VERSION=3.0.1
ENV SYSTEMC_PREFIX=/usr/local/systemc-${SYSTEMC_VERSION}
ENV SYSTEMC_INCLUDE=${SYSTEMC_PREFIX}/include
ENV SYSTEMC_LIBDIR=${SYSTEMC_PREFIX}/lib-linux64
ENV LD_LIBRARY_PATH=${SYSTEMC_LIBDIR}:${LD_LIBRARY_PATH}

RUN apt update && apt install -y curl cmake && apt clean && rm -rf /var/lib/apt/lists/* \
    && curl -o /tmp/systemc-${SYSTEMC_VERSION}.tgz -L https://github.com/accellera-official/systemc/archive/refs/tags/${SYSTEMC_VERSION}.tar.gz \
    && tar xzf /tmp/systemc-${SYSTEMC_VERSION}.tgz -C /tmp \
    && mkdir -p /tmp/systemc-${SYSTEMC_VERSION}/build && cd /tmp/systemc-${SYSTEMC_VERSION}/build \
    && touch /tmp/systemc-${SYSTEMC_VERSION}/docs/DEVELOPMENT.md \
    && ../configure --prefix=/usr/local/systemc-${SYSTEMC_VERSION} \
    && make -j \
    && make install \
    && cd ${HOME} && rm -rf /tmp/systemc-${SYSTEMC_VERSION}*
