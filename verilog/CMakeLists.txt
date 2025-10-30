cmake_minimum_required(VERSION 3.15)
project(VerilateSim LANGUAGES CXX)

find_package(verilator HINTS $ENV{VERILATOR_ROOT})

add_executable(tb_sv ${CMAKE_SOURCE_DIR}/src/testbench_sv.cpp)
# multiple SOURCES needs to specify PREFIX
verilate(tb_sv SOURCES ${CMAKE_SOURCE_DIR}/src/fa.sv ${CMAKE_SOURCE_DIR}/src/fa4.sv DIRECTORY ${CMAKE_BINARY_DIR}/build_sv PREFIX Vfa4 TOP_MODULE fa4 TRACE_VCD --Wall)

add_executable(tb_fan ${CMAKE_SOURCE_DIR}/src/testbench_fan.cpp)
verilate(tb_fan SOURCES ${CMAKE_SOURCE_DIR}/src/fan.sv DIRECTORY ${CMAKE_BINARY_DIR}/build_fan TOP_MODULE fan TRACE_VCD --Wall)

add_executable(tb_sc ${CMAKE_SOURCE_DIR}/src/testbench_sc.cpp)
verilate(tb_sc SOURCES ${CMAKE_SOURCE_DIR}/src/fa4.sv ${CMAKE_SOURCE_DIR}/src/fa.sv DIRECTORY ${CMAKE_BINARY_DIR}/build_sc TOP_MODULE fa4 SYSTEMC TRACE_VCD --Wall)
verilator_link_systemc(tb_sc)
