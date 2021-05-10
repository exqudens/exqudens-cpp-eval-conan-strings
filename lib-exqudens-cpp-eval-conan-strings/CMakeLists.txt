cmake_minimum_required(VERSION 3.20)
file(READ "${CMAKE_CURRENT_SOURCE_DIR}/../version.txt" RAW_VERSION)
string(STRIP "${RAW_VERSION}" VERSION)
project("lib-exqudens-cpp-eval-conan-strings" VERSION ${VERSION})

message("project: '${PROJECT_NAME}-${PROJECT_VERSION}'")

if(${CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT})
    set(CMAKE_INSTALL_PREFIX "${CMAKE_CURRENT_BINARY_DIR}/install" CACHE PATH "..." FORCE)
endif()

set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS FALSE)
#set(CMAKE_CXX_VISIBILITY_PRESET "hidden")
#set(CMAKE_VISIBILITY_INLINES_HIDDEN "YES")
if(${BUILD_SHARED_LIBS})
    set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS TRUE)
    #set(CMAKE_CXX_VISIBILITY_PRESET "default")
    #set(CMAKE_VISIBILITY_INLINES_HIDDEN "NO")
endif()

set(CMAKE_OBJECT_PATH_MAX 1000)
set(CMAKE_SHARED_LIBRARY_PREFIX "")
set(CMAKE_SHARED_MODULE_PREFIX "")
set(CMAKE_STATIC_LIBRARY_PREFIX "")
set(CMAKE_IMPORT_LIBRARY_PREFIX "")
set(CMAKE_STAGING_PREFIX "")
set(CMAKE_FIND_LIBRARY_PREFIXES "")
set(CMAKE_CXX_STANDARD 20)

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

if(DEFINED CMAKE_CONAN_PROGRAM)

    set(CMAKE_CONAN_SETTINGS_OS "Windows")
    set(CMAKE_CONAN_SETTINGS_OS_BUILD "Windows")
    set(CMAKE_CONAN_SETTINGS_ARCH "x86_64")
    set(CMAKE_CONAN_SETTINGS_ARCH_BUILD "x86_64")
    set(CMAKE_CONAN_SETTINGS_COMPILER "Visual Studio")
    set(CMAKE_CONAN_SETTINGS_COMPILER_VERSION "16")
    set(CMAKE_CONAN_SETTINGS_BUILD_TYPE "Release")

    set(CMAKE_CONAN_OPTIONS_SHARED "False")

    if(
        NOT "${CMAKE_HOST_SYSTEM_NAME}" STREQUAL "Windows"
        OR NOT "${CMAKE_SYSTEM_NAME}" STREQUAL "Windows"
        OR NOT "${CMAKE_HOST_SYSTEM_PROCESSOR}" STREQUAL "AMD64"
        OR NOT "${CMAKE_SYSTEM_PROCESSOR}" STREQUAL "AMD64"
    )
        message(WARNING "----------")
        message(WARNING "CMAKE_HOST_SYSTEM_NAME: '${CMAKE_HOST_SYSTEM_NAME}'")
        message(WARNING "CMAKE_SYSTEM_NAME: '${CMAKE_SYSTEM_NAME}'")
        message(WARNING "CMAKE_HOST_SYSTEM_PROCESSOR: '${CMAKE_HOST_SYSTEM_PROCESSOR}'")
        message(WARNING "CMAKE_SYSTEM_PROCESSOR: '${CMAKE_SYSTEM_PROCESSOR}'")
        message(WARNING "----------")
        message(FATAL_ERROR "Some setting is not supported!")
    endif()

    if(${BUILD_SHARED_LIBS})
        set(CMAKE_CONAN_OPTIONS_SHARED "True")
    endif()

    add_custom_target("${PROJECT_NAME}-conan-export-testing"
        COMMAND "${CMAKE_CONAN_PROGRAM}"
                export-pkg
                -f
                "${CMAKE_CURRENT_SOURCE_DIR}"
                test-user/test-channel
                --package-folder
                "${CMAKE_INSTALL_PREFIX}"
                --settings "os=${CMAKE_CONAN_SETTINGS_OS}"
                --settings "os_build=${CMAKE_CONAN_SETTINGS_OS_BUILD}"
                --settings "arch=${CMAKE_CONAN_SETTINGS_ARCH}"
                --settings "arch_build=${CMAKE_CONAN_SETTINGS_ARCH_BUILD}"
                --settings "compiler=${CMAKE_CONAN_SETTINGS_COMPILER}"
                --settings "compiler.version=${CMAKE_CONAN_SETTINGS_COMPILER_VERSION}"
                --settings "build_type=${CMAKE_CONAN_SETTINGS_BUILD_TYPE}"
                --options "shared=${CMAKE_CONAN_OPTIONS_SHARED}"
        COMMENT "execute: '${PROJECT_NAME}-conan-export-testing'"
    )

    add_custom_target("${PROJECT_NAME}-conan-export"
        COMMAND "${CMAKE_CONAN_PROGRAM}"
                export-pkg
                "${CMAKE_CURRENT_SOURCE_DIR}"
                --package-folder
                "${CMAKE_INSTALL_PREFIX}"
                --settings "os=${CMAKE_CONAN_SETTINGS_OS}"
                --settings "os_build=${CMAKE_CONAN_SETTINGS_OS_BUILD}"
                --settings "arch=${CMAKE_CONAN_SETTINGS_ARCH}"
                --settings "arch_build=${CMAKE_CONAN_SETTINGS_ARCH_BUILD}"
                --settings "compiler=${CMAKE_CONAN_SETTINGS_COMPILER}"
                --settings "compiler.version=${CMAKE_CONAN_SETTINGS_COMPILER_VERSION}"
                --settings "build_type=${CMAKE_CONAN_SETTINGS_BUILD_TYPE}"
                --options "shared=${CMAKE_CONAN_OPTIONS_SHARED}"
        COMMENT "execute: '${PROJECT_NAME}-conan-export'"
    )
endif()

add_library("${PROJECT_NAME}"
    "src/main/cpp/exqudens/evaluation/Strings.hpp"
    "src/main/cpp/exqudens/evaluation/Strings.cpp"
)
target_include_directories("${PROJECT_NAME}" PRIVATE
    "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/src/main/cpp>"
    "$<INSTALL_INTERFACE:include>"
)

install(
    TARGETS "${PROJECT_NAME}"
    INCLUDES DESTINATION "${CMAKE_INSTALL_PREFIX}/include"
    RUNTIME DESTINATION "${CMAKE_INSTALL_PREFIX}/bin"
    LIBRARY DESTINATION "${CMAKE_INSTALL_PREFIX}/lib"
    ARCHIVE DESTINATION "${CMAKE_INSTALL_PREFIX}/lib"
)

install(
    DIRECTORY "src/main/cpp/"
    DESTINATION "${CMAKE_INSTALL_PREFIX}/include"
    FILES_MATCHING PATTERN "*.hpp"
)

add_custom_target("${PROJECT_NAME}-cmake-install"
    COMMAND "${CMAKE_COMMAND}" --install "${CMAKE_CURRENT_BINARY_DIR}"
    COMMENT "execute: '${PROJECT_NAME}-cmake-install'"
)

add_custom_target("${PROJECT_NAME}-cmake-install-clean"
    COMMAND "${CMAKE_COMMAND}" -E rm -rf "${CMAKE_INSTALL_PREFIX}"
    COMMENT "execute: '${PROJECT_NAME}-cmake-install-clean'"
)

add_custom_target("${PROJECT_NAME}-cmake-clean"
    COMMAND "${CMAKE_COMMAND}" --build "${CMAKE_CURRENT_BINARY_DIR}" --target clean
    COMMENT "execute: '${PROJECT_NAME}-cmake-clean'"
)

add_dependencies("${PROJECT_NAME}-cmake-clean"   "${PROJECT_NAME}-cmake-install-clean")
add_dependencies("${PROJECT_NAME}-cmake-install" "${PROJECT_NAME}")
