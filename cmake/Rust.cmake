# Basic Rust CMake integration
find_program(CARGO_EXECUTABLE cargo REQUIRED)
if(NOT CARGO_EXECUTABLE)
    message(FATAL_ERROR "Cargo not found! Please install Rust and Cargo first.")
endif()
find_program(RUSTC_EXECUTABLE rustc REQUIRED)

function(add_rust_library target_name)
    set(options)
    set(oneValueArgs PATH TARGET_TRIPLE)
    set(multiValueArgs)
    cmake_parse_arguments(ARL "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    set(CARGO_TARGET_DIR ${CMAKE_CURRENT_BINARY_DIR}/cargo-build)
    if(ARL_TARGET_TRIPLE)
        # set(LIB_FILE "${CARGO_TARGET_DIR}/${ARL_TARGET_TRIPLE}/release/libengine.a")  # Comment this out
    else()
        # set(LIB_FILE "${CARGO_TARGET_DIR}/${CMAKE_BUILD_TYPE_LOWER}/libengine.a")
    endif()
    set(LIB_FILE "/home/paytondev/Documents/victor/engine/rs/target/armv7-unknown-linux-gnueabi/release/libengine.a")
    
    if(ARL_TARGET_TRIPLE)
        set(CARGO_TARGET_ARGS --target ${ARL_TARGET_TRIPLE})
    endif()

    if(CMAKE_BUILD_TYPE STREQUAL "Debug")
        set(CARGO_BUILD_TYPE "debug")
    else()
        set(CARGO_BUILD_TYPE "release")
        set(CARGO_BUILD_ARGS --release)
    endif()

    # Determine the target directory based on the platform

    # Debugging: Print the LIB_FILE path
    message(STATUS "LIB_FILE: ${LIB_FILE}")

    # Create a custom command to build the Rust library
    add_custom_command(
        OUTPUT ${LIB_FILE}
        COMMAND ${CARGO_EXECUTABLE} build ${CARGO_BUILD_ARGS} ${CARGO_TARGET_ARGS}
        WORKING_DIRECTORY ${ARL_PATH}
        COMMENT "Building Rust library ${target_name}"
    )

    # Create a custom target that depends on the library file
    add_custom_target(${target_name}_target ALL DEPENDS ${LIB_FILE})

    # Create an actual library target
    add_library(${target_name} STATIC IMPORTED GLOBAL)
    add_dependencies(${target_name} ${target_name}_target)
    set_target_properties(${target_name} PROPERTIES
        IMPORTED_LOCATION ${LIB_FILE}
        INTERFACE_INCLUDE_DIRECTORIES ${ARL_PATH}/include
    )
endfunction()