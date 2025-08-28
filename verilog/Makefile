ROOT_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
SRC_DIR := $(ROOT_DIR)src
BUILD_DIR := $(ROOT_DIR)build
TOP_MODULE := adder4

V_SRC := $(wildcard $(SRC_DIR)/*.v)

define pinfo
    @echo "ROOT_DIR = $(ROOT_DIR)"
	@echo "V_SRC = $(V_SRC)"
endef

.PHONY: default info build run clean

default: build

info:
	$(pinfo)

build: info
	# cd $(ROOT_DIR) && verilator --cc --exe $(SRC_DIR)/adder4.v $(SRC_DIR)/fulladder.v $(SRC_DIR)/testbenchVCD.cpp --trace --Mdir $(BUILD_DIR)
	cd $(ROOT_DIR) && verilator --cc --exe $(V_SRC) $(SRC_DIR)/testbenchVCD.cpp --trace --Mdir $(BUILD_DIR)
	$(MAKE) -j -C $(BUILD_DIR) -f V$(TOP_MODULE).mk

run:
	$(BUILD_DIR)/V$(TOP_MODULE)

clean:
	# cd "$(BUILD_DIR)"; \
	# 	&& rm -rfv *.o *.a;
	rm -rf "$(BUILD_DIR)" *.vcd
