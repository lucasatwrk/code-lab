cmake_minimum_required(VERSION 3.15)
project(VerilateSim LANGUAGES CXX)

include(${CMAKE_SOURCE_DIR}/verilate.cmake)

VERILATE(tb_sv
    TOP_MODULE        fa4
    VERILOG_SOURCES   ${CMAKE_SOURCE_DIR}/src/fa.sv ${CMAKE_SOURCE_DIR}/src/fa4.sv
    CPP_SOURCES       ${CMAKE_SOURCE_DIR}/src/testbench_sv.cpp
    INCLUDE_DIRS      ${CMAKE_SOURCE_DIR}/src
    VERILATOR_ARGS    "--trace" "--Wall"
    OUTPUT_DIR        ${CMAKE_BINARY_DIR}/svbuild
)

VERILATE(tb_sc
    SYSTEMC
    TOP_MODULE        fa4
    VERILOG_SOURCES   ${CMAKE_SOURCE_DIR}/src/fa.sv ${CMAKE_SOURCE_DIR}/src/fa4.sv
    CPP_SOURCES       ${CMAKE_SOURCE_DIR}/src/testbench_sc.cpp
    INCLUDE_DIRS      ${CMAKE_SOURCE_DIR}/src
    VERILATOR_ARGS    "--trace" "--Wall"
    OUTPUT_DIR        ${CMAKE_BINARY_DIR}/scbuild
)

VERILATE(tb_v
    TOP_MODULE        adder4
    VERILOG_SOURCES   ${CMAKE_SOURCE_DIR}/src/fulladder.v ${CMAKE_SOURCE_DIR}/src/adder4.v
    CPP_SOURCES       ${CMAKE_SOURCE_DIR}/src/testbench.cpp
    INCLUDE_DIRS      ${CMAKE_SOURCE_DIR}/src
    VERILATOR_ARGS    "--trace" "--Wall"
    OUTPUT_DIR        ${CMAKE_BINARY_DIR}/vbuild
)

VERILATE(tb_fan
    TOP_MODULE        fan
    VERILOG_SOURCES   ${CMAKE_SOURCE_DIR}/src/fa.sv ${CMAKE_SOURCE_DIR}/src/fan.sv
    CPP_SOURCES       ${CMAKE_SOURCE_DIR}/src/testbench_fan.cpp
    INCLUDE_DIRS      ${CMAKE_SOURCE_DIR}/src
    VERILATOR_ARGS    "--trace" "--Wall"
    OUTPUT_DIR        ${CMAKE_BINARY_DIR}/fanbuild
)