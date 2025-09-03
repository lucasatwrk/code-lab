ROOT_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
SRC_DIR := $(ROOT_DIR)src
BUILD_DIR := $(ROOT_DIR)build
TOP_MODULE := adder4

# global env variables
export SYSTEMC_VERSION=3.0.1
export SYSTEMC_PREFIX=/usr/local/systemc-${SYSTEMC_VERSION}
export SYSTEMC_INCLUDE=${SYSTEMC_PREFIX}/include
export SYSTEMC_LIBDIR=${SYSTEMC_PREFIX}/lib-linux64

V_SRC := $(wildcard $(SRC_DIR)/*.v)
SV_SRC := $(wildcard $(SRC_DIR)/*.sv)

define pinfo
    @echo "ROOT_DIR = $(ROOT_DIR)"
	@echo "V_SRC    = $(V_SRC)"
	@echo "SV_SRC   = $(SV_SRC)"
	@echo "SYSTEMC_VERSION = ${SYSTEMC_VERSION}"
	@echo "SYSTEMC_PREFIX  = ${SYSTEMC_PREFIX}"
	@echo "SYSTEMC_INCLUDE = ${SYSTEMC_INCLUDE}"
	@echo "SYSTEMC_LIBDIR  = ${SYSTEMC_LIBDIR}"
endef

.PHONY: default info build run clean

default: build

info:
	$(pinfo)

build: info
	# cd $(ROOT_DIR) && verilator --cc --exe $(SRC_DIR)/adder4.v $(SRC_DIR)/fulladder.v $(SRC_DIR)/testbenchVCD.cpp --trace --Mdir $(BUILD_DIR)
	cd $(ROOT_DIR) && verilator --cc --exe $(V_SRC) $(SRC_DIR)/testbenchVCD.cpp --trace --Mdir $(BUILD_DIR)
	$(MAKE) -j -C $(BUILD_DIR) -f V$(TOP_MODULE).mk

build-sv: export TOP_MODULE = fa4
build-sv: info
	cd $(ROOT_DIR) && verilator --cc --exe $(SV_SRC) $(SRC_DIR)/testbench_sv.cpp --top $(TOP_MODULE) --trace --Mdir $(BUILD_DIR)
	$(MAKE) -j -C $(BUILD_DIR) -f V$(TOP_MODULE).mk

build-sc: export TOP_MODULE = fa4
build-sc: info
	cd $(ROOT_DIR) && verilator --sc --exe $(SV_SRC) $(SRC_DIR)/testbench_sc.cpp --top $(TOP_MODULE) --trace --Mdir $(BUILD_DIR)
	$(MAKE) -j -C $(BUILD_DIR) -f V$(TOP_MODULE).mk

run:
	$(BUILD_DIR)/V$(TOP_MODULE)

run-sv: export TOP_MODULE = fa4
run-sv:
	$(BUILD_DIR)/Vfa4

run-sc: export TOP_MODULE = fa4
run-sc:
	$(BUILD_DIR)/V$(TOP_MODULE)

systemc-dl: systemc-$(SYSTEMC_VERSION).tgz

systemc-$(SYSTEMC_VERSION).tgz:
	curl -o systemc-$(SYSTEMC_VERSION).tgz -L https://github.com/accellera-official/systemc/archive/refs/tags/$(SYSTEMC_VERSION).tar.gz

systemc: systemc-$(SYSTEMC_VERSION).tgz
	tar xzf systemc-$(SYSTEMC_VERSION).tgz -C /tmp
	cd /tmp/systemc-$(SYSTEMC_VERSION) \
		&& mkdir -p objdir && cd objdir \
		&& ../configure --prefix=/usr/local/systemc-$(SYSTEMC_VERSION) \
		&& $(MAKE) -j \
		&& $(MAKE) install

clean:
	# cd "$(BUILD_DIR)"; \
	# 	&& rm -rfv *.o *.a;
	rm -rf "$(BUILD_DIR)" *.vcd
