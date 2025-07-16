cmake_minimum_required(VERSION 3.10)
project(BitCrack)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# OpenCL paths
set(OPENCL_INC "C:/Program Files (x86)/OCL_SDK_Light/include")
set(OPENCL_LIB "C:/Program Files (x86)/OCL_SDK_Light/lib/x86_64")

# Find OpenCL
find_path(OPENCL_INCLUDE_DIR CL/cl.h
    PATHS ${OPENCL_INC}
    DOC "OpenCL include directory"
)

find_library(OPENCL_LIBRARY
    NAMES OpenCL
    PATHS ${OPENCL_LIB}
    DOC "OpenCL library"
)

if(NOT OPENCL_INCLUDE_DIR)
    message(FATAL_ERROR "OpenCL include directory not found. Please check OPENCL_INC path.")
endif()

if(NOT OPENCL_LIBRARY)
    message(FATAL_ERROR "OpenCL library not found. Please check OPENCL_LIB path.")
endif()

# Include directories
include_directories(${CMAKE_SOURCE_DIR}/include)
include_directories(${OPENCL_INCLUDE_DIR})

# Source files
set(CORE_SOURCES
    src/core/secp256k1.cpp
    src/core/util.cpp
    src/core/Logger.cpp
    src/core/CmdParse.cpp
    src/core/checksum.cpp
    src/core/ripemd160.cpp
    src/core/Rng.cpp
    src/core/sha256.cpp
    src/core/Base58.cpp
    src/core/hash.cpp
    src/core/KeyFinder.cpp
)

set(OPENCL_SOURCES
    src/opencl/clContext.cpp
    src/opencl/clerrors.cpp
    src/opencl/clUtil.cpp
    src/opencl/CLKeySearchDevice.cpp
)

set(MAIN_SOURCES
    src/main/main.cpp
    src/main/DeviceManager.cpp
    src/main/ConfigFile.cpp
)

set(EMBEDCL_SOURCES
    src/embedcl.cpp
)

# Create embedcl executable
add_executable(embedcl ${EMBEDCL_SOURCES})
target_link_libraries(embedcl)

# Create main executable
add_executable(bitcrack ${MAIN_SOURCES} ${CORE_SOURCES} ${OPENCL_SOURCES})
target_link_libraries(bitcrack ${OPENCL_LIBRARY})

# Copy OpenCL kernel files to build directory
file(COPY src/*.cl DESTINATION ${CMAKE_BINARY_DIR})

# Build embedcl first
add_dependencies(bitcrack embedcl)

# Custom command to embed OpenCL kernels
add_custom_command(
    TARGET bitcrack
    PRE_BUILD
    COMMAND ${CMAKE_BINARY_DIR}/embedcl.exe
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    COMMENT "Embedding OpenCL kernels"
) 