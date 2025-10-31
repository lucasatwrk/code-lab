cmake_minimum_required(VERSION 3.15)
project(basic)

find_package(verilator HINTS $ENV{VERILATOR_ROOT})

add_executable(tb_ram ${PROJECT_SOURCE_DIR}/testbench/tb_ram.cpp)
verilate(tb_ram SOURCES ${PROJECT_SOURCE_DIR}/hdl/ram.sv DIRECTORY ${PROJECT_BINARY_DIR}/build_ram TOP_MODULE ram TRACE_VCD --Wall)

add_executable(tb_rom ${PROJECT_SOURCE_DIR}/testbench/tb_rom.cpp)
verilate(tb_rom SOURCES ${PROJECT_SOURCE_DIR}/hdl/rom.sv DIRECTORY ${PROJECT_BINARY_DIR}/build_rom TOP_MODULE rom TRACE_VCD --Wall
    VERILATOR_ARGS -GMEM_FILE="${PROJECT_SOURCE_DIR}/rom_init.hex")

add_executable(tb_romb ${PROJECT_SOURCE_DIR}/testbench/tb_rom.cpp)
verilate(tb_romb SOURCES ${PROJECT_SOURCE_DIR}/hdl/rom.sv DIRECTORY ${PROJECT_BINARY_DIR}/build_romb TOP_MODULE rom TRACE_VCD --Wall
    VERILATOR_ARGS -GMEM_FILE="${PROJECT_SOURCE_DIR}/rom_init.mem" -DBINARY_FILE)

set(LED_BASE_FREQ 1000)
add_executable(tb_led ${PROJECT_SOURCE_DIR}/testbench/tb_led.cpp)
verilate(tb_led SOURCES ${PROJECT_SOURCE_DIR}/hdl/led.sv DIRECTORY ${PROJECT_BINARY_DIR}/build_led TOP_MODULE led TRACE_VCD
    VERILATOR_ARGS -GBASE_FREQ=${LED_BASE_FREQ})
# somehow set `VERILATOR_ARGS -CFLAGS "-DBASE_FREQ=${LED_BASE_FREQ}"` option in verilate not working, use `target_compile_definitions` instead
target_compile_definitions(tb_led PRIVATE BASE_FREQ=${LED_BASE_FREQ})

add_executable(tb_led_stream ${PROJECT_SOURCE_DIR}/testbench/tb_led_stream.cpp)
verilate(tb_led_stream SOURCES ${PROJECT_SOURCE_DIR}/hdl/led_stream.sv ${PROJECT_SOURCE_DIR}/hdl/led.sv DIRECTORY ${PROJECT_BINARY_DIR}/build_led_stream PREFIX Vled_stream TOP_MODULE led_stream TRACE_VCD
    VERILATOR_ARGS -GBASE_FREQ=${LED_BASE_FREQ})
# somehow set `VERILATOR_ARGS -CFLAGS "-DBASE_FREQ=${LED_BASE_FREQ}"` option in verilate not working, use `target_compile_definitions` instead
target_compile_definitions(tb_led_stream PRIVATE BASE_FREQ=${LED_BASE_FREQ})
