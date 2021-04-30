cmake_minimum_required(VERSION 3.20)
project("eval-conan-strings" VERSION 1.0.0)

message("project: '${PROJECT_NAME}-${PROJECT_VERSION}'")

if(${CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT})
    set(CMAKE_INSTALL_PREFIX "${CMAKE_CURRENT_BINARY_DIR}/install" CACHE PATH "..." FORCE)
endif()

set(CMAKE_CONAN_PACKAGE_SHARED "False")
if(${BUILD_SHARED_LIBS})
    set(CMAKE_CONAN_PACKAGE_SHARED "True")
endif()

add_subdirectory("library-${CMAKE_PROJECT_NAME}")
add_subdirectory("test-${CMAKE_PROJECT_NAME}")
