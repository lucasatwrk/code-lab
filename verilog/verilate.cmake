function(VERILATE TARGET_NAME)
    cmake_parse_arguments(
        VERILATE
        "CPP;SYSTEMC"
        "TOP_MODULE;OUTPUT_DIR;VERILATOR_ROOT"
        "VERILOG_SOURCES;CPP_SOURCES;INCLUDE_DIRS;VERILATOR_ARGS"
        ${ARGN}
    )

    message("VERILATE: ${TARGET_NAME}")
    if(VERILATE_CPP)
        if(VERILATE_SYSTEMC)
            message(WARNING "Do not use both CPP and SYSTEMC, CPP is used as default")
            unset(VERILATE_SYSTEMC)
        endif()
        set(VERILATE_GENERATOR_OPTION --cc)
    elseif(VERILATE_SYSTEMC)
        set(VERILATE_GENERATOR_OPTION --sc)
        set(SYSTEMC_INCLUDE "$ENV{SYSTEMC_INCLUDE}")
    else()
        set(VERILATE_GENERATOR_OPTION --cc)
    endif()
    message("GENERATOR TYPE: ${VERILATE_GENERATOR_OPTION}")

    if(NOT VERILATE_TOP_MODULE)
        message(FATAL_ERROR "VERILATE: TOP_MODULE is required")
    endif()

    if(NOT VERILATE_VERILOG_SOURCES)
        message(FATAL_ERROR "VERILATE: VERILOG_SOURCES is required")
    endif()

    if(NOT VERILATE_CPP_SOURCES)
        message(FATAL_ERROR "VERILATE: CPP_SOURCES is required (e.g. testbench)")
    endif()

    if(NOT VERILATE_OUTPUT_DIR)
        set(VERILATE_OUTPUT_DIR "${CMAKE_BINARY_DIR}/verilated_${TARGET_NAME}")
    endif()

    if(NOT VERILATE_VERILATOR_ROOT)
        if($ENV{VERILATOR_ROOT})
            set(VERILATE_VERILATOR_ROOT $ENV{VERILATOR_ROOT})
        else()
            set(VERILATE_VERILATOR_ROOT "/usr/local/share/verilator")
        endif()
    endif()

    file(MAKE_DIRECTORY ${VERILATE_OUTPUT_DIR})

    find_program(VERILATOR_BIN verilator REQUIRED)
    message(DEBUG "VERILATOR_BIN: ${VERILATOR_BIN}")

    find_path(VERILATOR_INCLUDE_DIRS
        NAMES verilated.h
        HINTS ${VERILATE_VERILATOR_ROOT}/include
        REQUIRED
    )
    list(APPEND VERILATOR_INCLUDE_DIRS ${VERILATOR_INCLUDE_DIRS}/vltstd)
    if(VERILATE_SYSTEMC)
        if(SYSTEMC_INCLUDE)
            list(APPEND VERILATOR_INCLUDE_DIRS ${SYSTEMC_INCLUDE})
        else()
            message(WARNING "Environment variable 'SYSTEMC_INCLUDE' not set, please ensure that SystemC is installed or the build phase may fail")
        endif()
    endif()
    message(DEBUG "VERILATOR_INCLUDE_DIRS: ${VERILATOR_INCLUDE_DIRS}")

    set(VERILATOR_COMMAND ${VERILATOR_BIN}
        ${VERILATE_GENERATOR_OPTION}
        ${VERILATE_VERILOG_SOURCES}
        --exe ${VERILATE_CPP_SOURCES}
        --Mdir ${VERILATE_OUTPUT_DIR}
        --top ${VERILATE_TOP_MODULE}
        --build
        -o V${VERILATE_TOP_MODULE}
    )

    # optional args
    if(VERILATE_VERILATOR_ARGS)
        list(APPEND VERILATOR_COMMAND ${VERILATE_VERILATOR_ARGS})
    endif()
    # custom include
    foreach(INC_DIR IN LISTS VERILATE_INCLUDE_DIRS)
        list(APPEND VERILATOR_COMMAND -I${INC_DIR})
    endforeach()

    # check if using SystemC
    foreach(arg IN LISTS VERILATE_VERILATOR_ARGS)
        if(arg STREQUAL "--cc")
            message(WARNING "Do not use --cc in extra args, use the generator option 'CPP' instead")
        endif()
        if(arg STREQUAL "--sc")
            message(WARNING "Do not use --sc in extra args, use the generator option 'SYSTEMC' instead")
        endif()
    endforeach()

    message(VERBOSE "VERILATOR_COMMAND: ${VERILATOR_COMMAND}")
    add_custom_command(
        OUTPUT ${VERILATE_OUTPUT_DIR}/V${VERILATE_TOP_MODULE}.cpp
        COMMAND ${VERILATOR_COMMAND}
        DEPENDS ${VERILATE_VERILOG_SOURCES} ${VERILATE_CPP_SOURCES}
        COMMENT "Verilating ${TARGET_NAME}, top module: ${VERILATE_TOP_MODULE}..."
        WORKING_DIRECTORY ${VERILATE_OUTPUT_DIR}
    )

    add_custom_target(verilate_${TARGET_NAME}
        ALL
        DEPENDS ${VERILATE_OUTPUT_DIR}/V${VERILATE_TOP_MODULE}.cpp
    )

    # add_custom_target(
    #     verilate_${TARGET_NAME}
    #     COMMAND ${VERILATOR_COMMAND}
    #     DEPENDS ${VERILATE_VERILOG_SOURCES} ${VERILATE_CPP_SOURCES}
    #     COMMENT "Verilating ${VERILATE_TOP_MODULE}..."
    #     WORKING_DIRECTORY ${VERILATE_OUTPUT_DIR}
    # )

    # add_executable(${TARGET_NAME}
    #     ${VERILATE_OUTPUT_DIR}/V${VERILATE_TOP_MODULE}.cpp
    #     ${VERILATE_OUTPUT_DIR}/V${VERILATE_TOP_MODULE}__Syms.cpp
    #     ${VERILATE_CPP_SOURCES}
    # )
    # add_executable(${TARGET_NAME} ${VERILATE_CPP_SOURCES})

    # include dirs for verilated code
    # target_include_directories(${TARGET_NAME} PRIVATE
    #     ${VERILATE_OUTPUT_DIR}
    #     ${VERILATE_INCLUDE_DIRS}
    # )

    # add_dependencies(${TARGET_NAME} verilate_${TARGET_NAME})
    # target_include_directories(${TARGET_NAME} PRIVATE ${VERILATE_OUTPUT_DIR} ${VERILATOR_INCLUDE_DIRS})

    include(ExternalProject)
    ExternalProject_Add(verilated_project_${TARGET_NAME}
        PREFIX ${VERILATE_OUTPUT_DIR}
        SOURCE_DIR ${VERILATE_OUTPUT_DIR}
        CONFIGURE_COMMAND "" 
        BUILD_COMMAND make -C ${VERILATE_OUTPUT_DIR} -f V${VERILATE_TOP_MODULE}.mk
        INSTALL_COMMAND ""
        BUILD_IN_SOURCE FALSE
    )
endfunction()
