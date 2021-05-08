cmake_minimum_required(VERSION 3.20)
project("library-${CMAKE_PROJECT_NAME}" VERSION ${CMAKE_PROJECT_VERSION})

message("project: '${PROJECT_NAME}-${PROJECT_VERSION}'")

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY                "${CMAKE_CURRENT_BINARY_DIR}/bin")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE        "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELWITHDEBINFO "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_MINSIZEREL     "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG          "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY                "${CMAKE_CURRENT_BINARY_DIR}/lib")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELEASE        "${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELWITHDEBINFO "${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_MINSIZEREL     "${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG          "${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}")

set(CMAKE_LIBRARY_OUTPUT_DIRECTORY                "${CMAKE_CURRENT_BINARY_DIR}/lib")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE        "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELWITHDEBINFO "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_MINSIZEREL     "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG          "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")

add_custom_target("${PROJECT_NAME}-conan-install-clean"
    COMMAND "${CMAKE_COMMAND}" -E rm -rf
            "${CMAKE_CURRENT_BINARY_DIR}/packages"
    COMMAND "${CMAKE_COMMAND}" -E rm -f
            "${CMAKE_CURRENT_BINARY_DIR}/conan.lock"
            "${CMAKE_CURRENT_BINARY_DIR}/conan_imports_manifest.txt"
            "${CMAKE_CURRENT_BINARY_DIR}/conanbuildinfo.txt"
            "${CMAKE_CURRENT_BINARY_DIR}/conaninfo.txt"
            "${CMAKE_CURRENT_BINARY_DIR}/graph_info.json"
    COMMENT "execute: '${PROJECT_NAME}-conan-install-clean'"
)

add_custom_target("${PROJECT_NAME}-conan-install"
    COMMAND "${CMAKE_CONAN_PROGRAM}"
            install
            "${CMAKE_CURRENT_SOURCE_DIR}"
            --install-folder
            "${CMAKE_CURRENT_BINARY_DIR}"
            #--options "fmt:shared=${CMAKE_CONAN_PACKAGE_SHARED}"
    COMMENT "execute: '${PROJECT_NAME}-conan-install'"
)

add_custom_target("${PROJECT_NAME}-conan-export-testing"
    COMMAND "${CMAKE_CONAN_PROGRAM}"
            export-pkg
            -f
            "${CMAKE_CURRENT_SOURCE_DIR}"
            test-user/test-channel
            --package-folder
            "${CMAKE_INSTALL_PREFIX}/${PROJECT_NAME}-${PROJECT_VERSION}"
            --options "shared=${CMAKE_CONAN_PACKAGE_SHARED}"
    COMMENT "execute: '${PROJECT_NAME}-conan-export-testing'"
)

add_custom_target("${PROJECT_NAME}-conan-export"
    COMMAND "${CMAKE_CONAN_PROGRAM}"
            export-pkg
            "${CMAKE_CURRENT_SOURCE_DIR}"
            --package-folder
            "${CMAKE_INSTALL_PREFIX}/${PROJECT_NAME}-${PROJECT_VERSION}"
            --options "shared=${CMAKE_CONAN_PACKAGE_SHARED}"
    COMMENT "execute: '${PROJECT_NAME}-conan-export'"
)

add_library("${PROJECT_NAME}-object" OBJECT
    "src/main/cpp/exqudens/evaluation/Strings.hpp"
    "src/main/cpp/exqudens/evaluation/Strings.cpp"
)
target_include_directories("${PROJECT_NAME}-object" PUBLIC
    #"${CMAKE_CURRENT_BINARY_DIR}/packages/fmt/include"
    "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/src/main/cpp>"
    "$<INSTALL_INTERFACE:${PROJECT_NAME}-${PROJECT_VERSION}/include>"
)
#[[target_link_directories("${PROJECT_NAME}-object" PUBLIC
    "${CMAKE_CURRENT_BINARY_DIR}/packages/fmt/lib"
)]]
#[[target_link_libraries("${PROJECT_NAME}-object" PUBLIC
    "fmt"
)]]

add_library("${PROJECT_NAME}" "$<TARGET_OBJECTS:${PROJECT_NAME}-object>")
target_include_directories("${PROJECT_NAME}" PUBLIC
    #"${CMAKE_CURRENT_BINARY_DIR}/packages/fmt/include"
    "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/src/main/cpp>"
    "$<INSTALL_INTERFACE:${PROJECT_NAME}-${PROJECT_VERSION}/include>"
)
#[[target_link_directories("${PROJECT_NAME}" PUBLIC
    "${CMAKE_CURRENT_BINARY_DIR}/packages/fmt/lib"
)]]
#[[target_link_libraries("${PROJECT_NAME}" PUBLIC
    "fmt"
)]]

install(
    TARGETS "${PROJECT_NAME}"
    INCLUDES DESTINATION "${CMAKE_INSTALL_PREFIX}/${PROJECT_NAME}-${PROJECT_VERSION}/include"
    RUNTIME DESTINATION "${CMAKE_INSTALL_PREFIX}/${PROJECT_NAME}-${PROJECT_VERSION}/bin"
    LIBRARY DESTINATION "${CMAKE_INSTALL_PREFIX}/${PROJECT_NAME}-${PROJECT_VERSION}/lib"
    ARCHIVE DESTINATION "${CMAKE_INSTALL_PREFIX}/${PROJECT_NAME}-${PROJECT_VERSION}/lib"
)

install(
    DIRECTORY "src/main/cpp/"
    DESTINATION "${CMAKE_INSTALL_PREFIX}/${PROJECT_NAME}-${PROJECT_VERSION}/include"
    FILES_MATCHING PATTERN "*.hpp"
)

add_custom_target("${PROJECT_NAME}-cmake-install-clean"
    COMMAND "${CMAKE_COMMAND}" -E rm -rf "${CMAKE_INSTALL_PREFIX}/${PROJECT_NAME}-${PROJECT_VERSION}"
    COMMENT "execute: '${PROJECT_NAME}-cmake-install-clean'"
)

add_custom_target("${PROJECT_NAME}-cmake-install"
    COMMAND "${CMAKE_COMMAND}" --install "${CMAKE_CURRENT_BINARY_DIR}"
    COMMENT "execute: '${PROJECT_NAME}-cmake-install'"
)
