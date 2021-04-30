cmake_minimum_required(VERSION 3.20)
project("test-${CMAKE_PROJECT_NAME}" VERSION ${CMAKE_PROJECT_VERSION})

message("project: '${PROJECT_NAME}-${PROJECT_VERSION}'")

add_custom_target(${PROJECT_NAME}-conan-install
    COMMAND "${CMAKE_CONAN_PROGRAM}"
            install
            "${CMAKE_CURRENT_SOURCE_DIR}"
            --install-folder="${CMAKE_CURRENT_BINARY_DIR}"
            --options "library-eval-conan-strings:shared=${CMAKE_CONAN_PACKAGE_SHARED}"
    COMMENT "execute: '${PROJECT_NAME}-conan-install'"
)

if(NOT EXISTS "${CMAKE_CURRENT_BINARY_DIR}/conanbuildinfo.cmake")
    message(WARNING "WARNING: NOT EXISTS '${CMAKE_CURRENT_BINARY_DIR}/conanbuildinfo.cmake'")
    return()
endif()
include("${CMAKE_CURRENT_BINARY_DIR}/conanbuildinfo.cmake")
conan_basic_setup()

set(CMAKE_CXX_STANDARD 20)

add_executable(${PROJECT_NAME}-executable "src/test/cpp/main.cpp")
target_link_libraries(${PROJECT_NAME}-executable PRIVATE
    "${CONAN_LIBS}"
)

add_custom_target(${PROJECT_NAME}
    COMMAND "${CMAKE_COMMAND}"
            -E
            env
            PATH="${CMAKE_RUNTIME_OUTPUT_DIRECTORY}"
            "$<TARGET_FILE:${PROJECT_NAME}-executable>"
            "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/$<TARGET_FILE:${PROJECT_NAME}-executable>"
    WORKING_DIRECTORY "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}"
    COMMENT "execute: '$<TARGET_PROPERTY:NAME>'"
)
