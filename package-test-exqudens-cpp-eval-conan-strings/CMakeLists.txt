cmake_minimum_required(VERSION 3.20)
project("package-test-${CMAKE_PROJECT_NAME}" VERSION ${CMAKE_PROJECT_VERSION})

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

set(PROJECT_PATH_LIST
    "${CMAKE_CURRENT_BINARY_DIR}/packages/library-${CMAKE_PROJECT_NAME}/bin"
    "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}"
)
cmake_path(CONVERT "${PROJECT_PATH_LIST}" TO_NATIVE_PATH_LIST PROJECT_NATIVE_PATH_LIST NORMALIZE)

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
            --options "library-${CMAKE_PROJECT_NAME}:shared=${CMAKE_CONAN_PACKAGE_SHARED}"
    COMMENT "execute: '${PROJECT_NAME}-conan-install'"
)

add_executable("${PROJECT_NAME}-executable" "src/test/cpp/main.cpp")
target_include_directories("${PROJECT_NAME}-executable" PUBLIC
    #"${CMAKE_CURRENT_BINARY_DIR}/packages/fmt/include"
    "${CMAKE_CURRENT_BINARY_DIR}/packages/library-exqudens-cpp-eval-conan-strings/include"
)
target_link_directories("${PROJECT_NAME}-executable" PUBLIC
    #"${CMAKE_CURRENT_BINARY_DIR}/packages/fmt/lib"
    "${CMAKE_CURRENT_BINARY_DIR}/packages/library-exqudens-cpp-eval-conan-strings/lib"
)
target_link_libraries("${PROJECT_NAME}-executable" PUBLIC
    #"fmt"
    "library-exqudens-cpp-eval-conan-strings"
    "test-${CMAKE_PROJECT_NAME}-interface"
)
if(${BUILD_SHARED_LIBS})
    get_filename_component(CXX_COMPILER_DIR ${CMAKE_CXX_COMPILER} DIRECTORY)
    foreach(fileName
        "libstdc++-6.dll"
        "libgcc_s_seh-1.dll"
        "libwinpthread-1.dll"
        )
        if(EXISTS ${CXX_COMPILER_DIR}/${fileName})
            add_custom_command(
                TARGET "${PROJECT_NAME}-executable"
                PRE_BUILD
                COMMAND ${CMAKE_COMMAND}
                ARGS -E copy "${CXX_COMPILER_DIR}/${fileName}" "$<TARGET_FILE_DIR:${PROJECT_NAME}-executable>"
                BYPRODUCTS ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${fileName}
                #COMMENT "Copying '${fileName}' shared library."
            )
        endif()
    endforeach()
endif()

add_custom_target("${PROJECT_NAME}"
    COMMAND "${CMAKE_COMMAND}"
            -E
            env
            "PATH=\"${PROJECT_NATIVE_PATH_LIST}\""
            "$<TARGET_FILE:${PROJECT_NAME}-executable>"
    WORKING_DIRECTORY "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}"
    COMMENT "execute: '${PROJECT_NAME}'"
)
