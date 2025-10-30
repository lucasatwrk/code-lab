cmake_minimum_required(VERSION 3.15)
project(basic)

find_package(verilator HINTS $ENV{VERILATOR_ROOT})

add_executable(tb_ram ${PROJECT_SOURCE_DIR}/testbench/tb_ram.cpp)
verilate(tb_ram SOURCES ${PROJECT_SOURCE_DIR}/hdl/ram.sv DIRECTORY ${CMAKE_BINARY_DIR}/build_ram TOP_MODULE ram TRACE_VCD --Wall)

add_executable(tb_rom ${PROJECT_SOURCE_DIR}/testbench/tb_rom.cpp)
verilate(tb_rom SOURCES ${PROJECT_SOURCE_DIR}/hdl/rom.sv DIRECTORY ${CMAKE_BINARY_DIR}/build_rom TOP_MODULE rom TRACE_VCD --Wall
    VERILATOR_ARGS -GMEM_FILE="${PROJECT_SOURCE_DIR}/rom_init.hex")

add_executable(tb_romb ${PROJECT_SOURCE_DIR}/testbench/tb_rom.cpp)
verilate(tb_romb SOURCES ${PROJECT_SOURCE_DIR}/hdl/rom.sv DIRECTORY ${CMAKE_BINARY_DIR}/build_romb TOP_MODULE rom TRACE_VCD --Wall
    VERILATOR_ARGS -GMEM_FILE="${PROJECT_SOURCE_DIR}/rom_init.mem" -DBINARY_FILE)