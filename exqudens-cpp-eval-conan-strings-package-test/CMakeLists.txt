cmake_minimum_required(VERSION 3.20)
project("${CMAKE_PROJECT_NAME}-package-test" VERSION "${CMAKE_PROJECT_VERSION}")

message("project: '${PROJECT_NAME}-${PROJECT_VERSION}'")

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY                "${PROJECT_BINARY_DIR}/bin")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE        "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELWITHDEBINFO "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_MINSIZEREL     "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG          "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY                "${PROJECT_BINARY_DIR}/lib")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELEASE        "${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELWITHDEBINFO "${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_MINSIZEREL     "${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG          "${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}")

set(CMAKE_LIBRARY_OUTPUT_DIRECTORY                "${PROJECT_BINARY_DIR}/lib")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE        "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELWITHDEBINFO "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_MINSIZEREL     "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG          "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")

set("${PROJECT_NAME}_CONAN_INSTALL_PREFIX" "${PROJECT_BINARY_DIR}/conan-install")
set("${PROJECT_NAME}_CMAKE_PREFIX_PATH" "")

if(DEFINED "CONAN_COMMAND")
    set_conan_settings(CONAN_SETTINGS
        "${CMAKE_SYSTEM_NAME}"
        "${CMAKE_SYSTEM_PROCESSOR}"
        "${CMAKE_CXX_COMPILER_ID}"
        "${CMAKE_CXX_COMPILER_VERSION}"
        "${CMAKE_MSVC_RUNTIME_LIBRARY}"
        "${CMAKE_CXX_STANDARD}"
        "${CMAKE_BUILD_TYPE}"
    )

    set_conan_options(CONAN_OPTIONS
        "${BUILD_SHARED_LIBS}"
        "${CMAKE_PROJECT_NAME}-lib"
    )

    add_custom_target_conan_install("${PROJECT_NAME}-conan-install"
        "${CONAN_COMMAND}"
        "${PROJECT_SOURCE_DIR}/conanfile.py"
        "${${PROJECT_NAME}_CONAN_INSTALL_PREFIX}"
        "${CONAN_SETTINGS}"
        "${CONAN_OPTIONS}"
    )

    #[[file(
        GLOB "${PROJECT_NAME}_CONAN_PACKAGES"
        LIST_DIRECTORIES "true"
        "${${PROJECT_NAME}_CONAN_INSTALL_PREFIX}/*"
    )
    foreach(package ${${PROJECT_NAME}_CONAN_PACKAGES})
        if(IS_DIRECTORY "${package}")
            list(PREPEND "${PROJECT_NAME}_CMAKE_PREFIX_PATH" "${package}")
        endif()
    endforeach()]]

    if(EXISTS "${${PROJECT_NAME}_CONAN_INSTALL_PREFIX}/conan_paths.cmake")
        set(CMAKE_PREFIX_PATH "")
        include("${${PROJECT_NAME}_CONAN_INSTALL_PREFIX}/conan_paths.cmake")
        list(REMOVE_ITEM "CMAKE_PREFIX_PATH" "${${PROJECT_NAME}_CONAN_INSTALL_PREFIX}")
        foreach(package ${CMAKE_PREFIX_PATH})
            if(IS_DIRECTORY "${package}")
                list(PREPEND "${PROJECT_NAME}_CMAKE_PREFIX_PATH" "${package}")
            endif()
        endforeach()
        set(CMAKE_PREFIX_PATH "")
    endif()
endif()

if("" STREQUAL "${${PROJECT_NAME}_CMAKE_PREFIX_PATH}")
    message(WARNING "${PROJECT_NAME}_CMAKE_PREFIX_PATH is empty")
    return()
endif()

find_package("${CMAKE_PROJECT_NAME}-lib" "${CMAKE_PROJECT_VERSION}" REQUIRED CONFIG PATHS ${${PROJECT_NAME}_CMAKE_PREFIX_PATH} NO_DEFAULT_PATH)

file(REMOVE_RECURSE "${PROJECT_BINARY_DIR}/generated")
get_target_property("TEST_LIB_SOURCES" "${CMAKE_PROJECT_NAME}-test-lib" SOURCES)
foreach(testLibSource ${TEST_LIB_SOURCES})
    get_filename_component(testLibSourceDir "${testLibSource}" DIRECTORY)
    file(COPY "${CMAKE_SOURCE_DIR}/${CMAKE_PROJECT_NAME}-test/${testLibSource}" DESTINATION "${PROJECT_BINARY_DIR}/generated/${testLibSourceDir}")
endforeach()
add_library("${PROJECT_NAME}-lib" STATIC
    "${PROJECT_BINARY_DIR}/generated/src/test/cpp/exqudens/evaluation/StringsTests.hpp"
    "${PROJECT_BINARY_DIR}/generated/src/test/cpp/exqudens/evaluation/StringsTests.cpp"
)
target_include_directories("${PROJECT_NAME}-lib" PUBLIC
    "${PROJECT_BINARY_DIR}/generated/src/test/cpp"
)
target_link_libraries("${PROJECT_NAME}-lib" PRIVATE
    "${CMAKE_PROJECT_NAME}-lib::${CMAKE_PROJECT_NAME}-lib"
)

add_executable("${PROJECT_NAME}-executable" "src/test/cpp/main.cpp")
target_link_libraries("${PROJECT_NAME}-executable" PRIVATE
    "${PROJECT_NAME}-lib"
)
if("${BUILD_SHARED_LIBS}")
    foreach(package ${${PROJECT_NAME}_CMAKE_PREFIX_PATH})
        if(IS_DIRECTORY "${package}" AND IS_DIRECTORY "${package}/bin")
            file(
                GLOB FILE_NAMES
                RELATIVE "${package}/bin"
                "${package}/bin/*"
            )
            foreach(fileName ${FILE_NAMES})
                add_custom_command(
                    TARGET "${PROJECT_NAME}-executable"
                    PRE_BUILD
                    COMMAND ${CMAKE_COMMAND}
                    ARGS -E copy "${package}/bin/${fileName}" "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}"
                    BYPRODUCTS "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${fileName}"
                    #COMMENT "custom-command-copy: '${package}/bin/${fileName}' to '${CMAKE_RUNTIME_OUTPUT_DIRECTORY}'"
                    VERBATIM
                )
            endforeach()
        endif()
    endforeach()
    if("${MINGW}")
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
                    #COMMENT "custom-command-copy: '${CXX_COMPILER_DIR}/${fileName}' to '${CMAKE_RUNTIME_OUTPUT_DIRECTORY}'"
                    VERBATIM
                )
            endif()
        endforeach()
    endif()
endif()

add_custom_target("${PROJECT_NAME}"
    COMMAND "${CMAKE_COMMAND}"
            -E
            env
            "PATH=${CMAKE_RUNTIME_OUTPUT_DIRECTORY}"
            "$<TARGET_FILE:${PROJECT_NAME}-executable>"
    WORKING_DIRECTORY "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}"
    COMMENT "custom-target: '${PROJECT_NAME}'"
    VERBATIM
)
