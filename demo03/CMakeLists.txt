cmake_minimum_required(VERSION 3.0...3.20 FATAL_ERROR)

project(hello_triangle VERSION 3.3.8 LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 17) # this does nothing for MSVC, use target_compile_options below
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS ON)
#set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/../cmake/modules/")

include(GNUInstallDirs)
include(CMakeDependentOption)
link_directories(${CMAKE_SOURCE_DIR}/../libs)
include_directories(../includes/ /usr/local/include ../libs/)


#find_package(GLFW3 REQUIRED)
#message(STATUS "Found GLFW3 in ${GLFW3_INCLUDE_DIR}")
find_package(glfw3  REQUIRED)

set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wall")
# find_package(OpenGL REQUIRED)
# add_definitions(${OPENGL_DEFINITIONS})
find_package(X11 REQUIRED)
# note that the order is important for setting the libs
# use pkg-config --libs $(pkg-config --print-requires --print-requires-private glfw3) in a terminal to confirm
set(LIBS glfw pthread )
set (CMAKE_CXX_LINK_EXECUTABLE "${CMAKE_CXX_LINK_EXECUTABLE} -ldl")

#list(APPEND CMAKE_MODULE_PATH "${GLFW_SOURCE_DIR}/CMake/modules")

#add_library(GLAD "${CMAKE_SOURCE_DIR}/../libs/glad.c")
#set(LIBS ${LIBS} GLAD)

add_executable(${PROJECT_NAME} hello_triangle.cc "${CMAKE_SOURCE_DIR}/../libs/glad.c")
target_link_libraries(${PROJECT_NAME}  ${LIBS})

