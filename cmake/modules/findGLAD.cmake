cmake_minimum_required(VERSION 3.5)
include(ExternalProject)

#########################################################################################
# GLAD
#########################################################################################
option(DOWNLOAD_GLAD "Download and build GLAD" OFF)

# Build settings
set(GLAD_PREFIX ${CMAKE_BINARY_DIR}/GLAD)
set(GLAD_INCLUDE_DIR ${GLAD_PREFIX}/include)
set(GLAD_LIBRARY ${GLAD_PREFIX}/lib/libglad.a)
set(GLAD_PROFILE "core" CACHE STRING "")
set(GLAD_API "gl=3.3" CACHE STRING "")
set(GLAD_SPEC "gl" CACHE STRING "")
set(GLAD_GENERATOR "c" CACHE STRING "")
set(GLAD_EXTENSIONS "" CACHE STRING "")
set(GLAD_REPRODUCIBLE ON CACHE BOOL "")
set(GLAD_INSTALL ON CACHE BOOL "")

# Use GLAD generator from system
if(NOT DOWNLOAD_GLAD)
    find_program(GLAD_GEN "glad")
    if(GLAD_GEN)
        message(STATUS "Found GLAD binary: ${GLAD_GEN}")
        set(GLAD_SOURCES
            ${GLAD_INCLUDE_DIR}/glad/glad.h
            ${GLAD_PREFIX}/src/glad.c)
        add_custom_command(
            OUTPUT ${GLAD_SOURCES}
            COMMAND ${GLAD_GEN}
              --profile=${GLAD_PROFILE}
              --out-path=${GLAD_PREFIX}
              --api=${GLAD_API}
              --generator=${GLAD_GENERATOR}
              --extensions=${GLAD_EXTENSIONS}
              --spec=${GLAD_SPEC}
              --reproducible
            WORKING_DIRECTORY ${GLAD_PREFIX}
            COMMENT "Generating GLAD")
        add_custom_target(glad-generate-files DEPENDS ${GLAD_SOURCES})
        set_source_files_properties(${GLAD_SOURCES} PROPERTIES GENERATED TRUE)
        add_library(glad ${GLAD_SOURCES})
        add_dependencies(glad glad-generate-files)
        target_include_directories(glad
            PUBLIC $<BUILD_INTERFACE:${GLAD_INCLUDE_DIR}>
            INTERFACE $<INSTALL_INTERFACE:include/glad>)
        set_target_properties(glad PROPERTIES
            LINKER_LANGUAGE C
            ARCHIVE_OUTPUT_DIRECTORY ${GLAD_PREFIX}/lib
            LIBRARY_OUTPUT_DIRECTORY ${GLAD_PREFIX}/lib)
    else(GLAD_GEN)
        message(STATUS "GLAD generator - not found")
        set(DOWNLOAD_GLAD ON)
    endif(GLAD_GEN)
endif(NOT DOWNLOAD_GLAD)

# Download GLFW3 locally into the binary directory
if(DOWNLOAD_GLAD)
    message(STATUS "GLAD will be downloaded and built")
    # Download and build
    ExternalProject_Add(GLAD
        URL "https://github.com/Dav1dde/glad/archive/v0.1.29.zip"
        PREFIX ${GLAD_PREFIX}
        CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${GLAD_PREFIX} -DGLAD_INSTALL=${GLAD_INSTALL}
        UPDATE_COMMAND "")
endif(DOWNLOAD_GLAD)

# Global Variables
set(GLAD_INCLUDE_DIRS ${GLAD_INCLUDE_DIR} CACHE STRING "GLAD Include directories")
set(GLAD_LIBRARIES ${GLAD_LIBRARY} CACHE STRING "GLAD Libraries")
