cmake_minimum_required(VERSION 3.20)
file(READ "${CMAKE_CURRENT_SOURCE_DIR}/../version.txt" RAW_VERSION)
string(STRIP "${RAW_VERSION}" VERSION)
project("exqudens-cpp-eval-conan-strings-test" VERSION "${VERSION}")

message("project: '${PROJECT_NAME}-${PROJECT_VERSION}'")

if(${CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT})
    set(CMAKE_INSTALL_PREFIX "${CMAKE_CURRENT_BINARY_DIR}/install" CACHE PATH "..." FORCE)
endif()

set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS FALSE)
#set(CMAKE_CXX_VISIBILITY_PRESET "hidden")
#set(CMAKE_VISIBILITY_INLINES_HIDDEN "YES")
if("${BUILD_SHARED_LIBS}")
    set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS TRUE)
    #set(CMAKE_CXX_VISIBILITY_PRESET "default")
    #set(CMAKE_VISIBILITY_INLINES_HIDDEN "NO")
else()
    if("${MINGW}")
        set(CMAKE_CXX_STANDARD_LIBRARIES "-static-libgcc -static-libstdc++ ${CMAKE_CXX_STANDARD_LIBRARIES}")
        set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,-Bstatic,--whole-archive -lwinpthread -Wl,--no-whole-archive")
    endif()
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

if(DEFINED CONAN_PROGRAM)
    if("${CMAKE_SYSTEM_NAME}" STREQUAL "Windows")
        set(CONAN_SETTINGS --settings "os=${CMAKE_SYSTEM_NAME}")
    elseif("${CMAKE_SYSTEM_NAME}" STREQUAL "Linux")
        set(CONAN_SETTINGS --settings "os=${CMAKE_SYSTEM_NAME}")
    elseif("${CMAKE_SYSTEM_NAME}" STREQUAL "Darwin")
        set(CONAN_SETTINGS --settings "os=Macos")
    else()
        message(FATAL_ERROR "Unsupported CMAKE_SYSTEM_NAME: '${CMAKE_SYSTEM_NAME}'")
    endif()

    if("${CMAKE_SYSTEM_PROCESSOR}" STREQUAL "AMD64")
        set(CONAN_SETTINGS ${CONAN_SETTINGS} --settings "arch=x86_64")
    else()
        message(FATAL_ERROR "Unsupported CMAKE_SYSTEM_PROCESSOR: '${CMAKE_SYSTEM_PROCESSOR}'")
    endif()

    if(
        "${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC"
        AND "${CMAKE_CXX_COMPILER_VERSION}" VERSION_GREATER_EQUAL "19"
    )
        set(CONAN_SETTINGS ${CONAN_SETTINGS} --settings "compiler=Visual Studio")
        set(CONAN_SETTINGS ${CONAN_SETTINGS} --settings "compiler.version=16")
    elseif(
        "${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU"
        AND "${CMAKE_CXX_COMPILER_VERSION}" VERSION_GREATER_EQUAL "10"
    )
        set(CONAN_SETTINGS ${CONAN_SETTINGS} --settings "compiler=gcc")
        set(CONAN_SETTINGS ${CONAN_SETTINGS} --settings "compiler.version=10")
        set(CONAN_SETTINGS ${CONAN_SETTINGS} --settings "compiler.libcxx=libstdc++11")
    else()
        message(FATAL_ERROR "Unsupported CMAKE_CXX_COMPILER_ID: '${CMAKE_CXX_COMPILER_ID}' and CMAKE_CONAN_SETTINGS_COMPILER_VERSION: '${CMAKE_CONAN_SETTINGS_COMPILER_VERSION}'")
    endif()

    if("${BUILD_SHARED_LIBS}")
        set(CONAN_OPTIONS_SHARED "True")
    else()
        set(CONAN_OPTIONS_SHARED "False")
    endif()

    set(CONAN_OPTIONS --options "exqudens-cpp-eval-conan-strings-lib:shared=${CONAN_OPTIONS_SHARED}")

    if(NOT EXISTS "${CMAKE_CURRENT_BINARY_DIR}/conan_paths.cmake")
        execute_process(
            COMMAND "${CONAN_PROGRAM}"
                    install
                    "${CMAKE_CURRENT_SOURCE_DIR}"
                    --install-folder
                    "${CMAKE_CURRENT_BINARY_DIR}"
                    ${CONAN_SETTINGS}
                    ${CONAN_OPTIONS}
            COMMAND_ERROR_IS_FATAL ANY
        )
    endif()

    include("${CMAKE_CURRENT_BINARY_DIR}/conan_paths.cmake")

    add_custom_target("${PROJECT_NAME}-conan-install-clean"
        COMMAND "${CMAKE_COMMAND}" -E rm -f
                "${CMAKE_CURRENT_BINARY_DIR}/conan.lock"
                "${CMAKE_CURRENT_BINARY_DIR}/conan_paths.cmake"
                "${CMAKE_CURRENT_BINARY_DIR}/conanbuildinfo.txt"
                "${CMAKE_CURRENT_BINARY_DIR}/conaninfo.txt"
                #"${CMAKE_CURRENT_BINARY_DIR}/Findexqudens-cpp-eval-conan-strings-lib.cmake"
                "${CMAKE_CURRENT_BINARY_DIR}/graph_info.json"
        COMMENT "execute: '${PROJECT_NAME}-conan-install-clean'"
        VERBATIM
    )
endif()

find_package("exqudens-cpp-eval-conan-strings-lib" 1.0.0 REQUIRED)

add_library("${PROJECT_NAME}-interface" INTERFACE
    "src/test/cpp/exqudens/evaluation/StringsTests.hpp"
)
target_include_directories("${PROJECT_NAME}-interface" INTERFACE
    "src/test/cpp"
)
target_link_libraries("${PROJECT_NAME}-interface" INTERFACE
    "exqudens-cpp-eval-conan-strings-lib::exqudens-cpp-eval-conan-strings-lib"
)

add_executable("${PROJECT_NAME}-executable" "src/test/cpp/main.cpp")
target_link_libraries("${PROJECT_NAME}-executable" PRIVATE
    "${PROJECT_NAME}-interface"
)
if("${BUILD_SHARED_LIBS}" AND "${MINGW}")
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
            "PATH=${CMAKE_RUNTIME_OUTPUT_DIRECTORY}"
            "$<TARGET_FILE:${PROJECT_NAME}-executable>"
    WORKING_DIRECTORY "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}"
    COMMENT "execute: '${PROJECT_NAME}'"
    VERBATIM
)

add_custom_target("${PROJECT_NAME}-cmake-clean"
    COMMAND "${CMAKE_COMMAND}" --build "${CMAKE_CURRENT_BINARY_DIR}" --target clean
    COMMENT "execute: '${PROJECT_NAME}-cmake-clean'"
    VERBATIM
)
