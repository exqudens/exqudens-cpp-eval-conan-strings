cmake_minimum_required(VERSION 3.20)
project("library-${CMAKE_PROJECT_NAME}" VERSION ${CMAKE_PROJECT_VERSION})

message("project: '${PROJECT_NAME}-${PROJECT_VERSION}'")

add_custom_target(${PROJECT_NAME}-conan-install
    COMMAND "${CMAKE_CONAN_PROGRAM}"
            install
            "${CMAKE_CURRENT_SOURCE_DIR}"
            --install-folder="${CMAKE_CURRENT_BINARY_DIR}"
            #--options "fmt:shared=${CMAKE_CONAN_PACKAGE_SHARED}"
    COMMENT "execute: '${PROJECT_NAME}-conan-install'"
)

add_custom_target(${PROJECT_NAME}-conan-export-testing
    COMMAND "${CMAKE_CONAN_PROGRAM}"
            export-pkg
            -f
            "${CMAKE_CURRENT_SOURCE_DIR}"
            test-user/test-channel
            --package-folder="${CMAKE_INSTALL_PREFIX}/${PROJECT_NAME}-${PROJECT_VERSION}"
            --options "shared=${CMAKE_CONAN_PACKAGE_SHARED}"
    COMMENT "execute: '${PROJECT_NAME}-conan-export-testing'"
)

add_custom_target(${PROJECT_NAME}-conan-export
    COMMAND "${CMAKE_CONAN_PROGRAM}"
            export-pkg
            "${CMAKE_CURRENT_SOURCE_DIR}"
            --package-folder="${CMAKE_INSTALL_PREFIX}/${PROJECT_NAME}-${PROJECT_VERSION}"
            --options "shared=${CMAKE_CONAN_PACKAGE_SHARED}"
    COMMENT "execute: '${PROJECT_NAME}-conan-export'"
)

if(NOT EXISTS "${CMAKE_CURRENT_BINARY_DIR}/conanbuildinfo.cmake")
    message(WARNING "WARNING: NOT EXISTS '${CMAKE_CURRENT_BINARY_DIR}/conanbuildinfo.cmake'")
    return()
endif()
include("${CMAKE_CURRENT_BINARY_DIR}/conanbuildinfo.cmake")
conan_basic_setup()

add_library(${PROJECT_NAME}-object OBJECT
    "src/main/cpp/exqudens/evaluation/Strings.hpp"
    "src/main/cpp/exqudens/evaluation/Strings.cpp"
)
target_include_directories(${PROJECT_NAME}-object PUBLIC
    "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/src/main/cpp>"
    "$<INSTALL_INTERFACE:${PROJECT_NAME}-${PROJECT_VERSION}/include>"
)
target_link_libraries(${PROJECT_NAME}-object PUBLIC
    "${CONAN_LIBS}"
)

add_library(${PROJECT_NAME} "$<TARGET_OBJECTS:${PROJECT_NAME}-object>")
target_link_libraries(${PROJECT_NAME} PUBLIC
    "${CONAN_LIBS}"
)

install(
    TARGETS ${PROJECT_NAME}
    INCLUDES DESTINATION "${PROJECT_NAME}-${PROJECT_VERSION}/include"
    RUNTIME DESTINATION "${PROJECT_NAME}-${PROJECT_VERSION}/bin"
    LIBRARY DESTINATION "${PROJECT_NAME}-${PROJECT_VERSION}/lib"
    ARCHIVE DESTINATION "${PROJECT_NAME}-${PROJECT_VERSION}/lib"
)

install(
    DIRECTORY "src/main/cpp/"
    DESTINATION "${PROJECT_NAME}-${PROJECT_VERSION}/include"
    FILES_MATCHING PATTERN "*.hpp"
)
