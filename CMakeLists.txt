cmake_minimum_required(VERSION 3.20)
project("exqudens-cpp-eval-conan-strings" VERSION 1.0.0)

message("project: '${PROJECT_NAME}-${PROJECT_VERSION}'")

if(${CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT})
    set(CMAKE_INSTALL_PREFIX "${CMAKE_CURRENT_BINARY_DIR}/install" CACHE PATH "..." FORCE)
endif()

set(CMAKE_CONAN_PACKAGE_SHARED "False")
set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS FALSE)
#set(CMAKE_CXX_VISIBILITY_PRESET "hidden")
#set(CMAKE_VISIBILITY_INLINES_HIDDEN "YES")
if(${BUILD_SHARED_LIBS})
    set(CMAKE_CONAN_PACKAGE_SHARED "True")
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

add_subdirectory("library-${PROJECT_NAME}")
add_subdirectory("test-${PROJECT_NAME}")
add_subdirectory("package-test-${PROJECT_NAME}")

add_custom_target("${PROJECT_NAME}-cmake-clean"
    COMMAND "${CMAKE_COMMAND}" --build "${CMAKE_CURRENT_BINARY_DIR}" --target clean
    COMMENT "execute: '${PROJECT_NAME}-cmake-clean'"
)

add_custom_target("${PROJECT_NAME}-clean"
    COMMENT "execute: '${PROJECT_NAME}-clean'"
)

add_dependencies("${PROJECT_NAME}-clean"
    "package-test-${PROJECT_NAME}-conan-install-clean"
    "test-${PROJECT_NAME}-conan-install-clean"
    "library-${PROJECT_NAME}-conan-install-clean"
    "library-${PROJECT_NAME}-cmake-install-clean"
    "${PROJECT_NAME}-cmake-clean"
)

add_dependencies("library-${PROJECT_NAME}"                      "library-${PROJECT_NAME}-object")
add_dependencies("test-${PROJECT_NAME}-executable"              "library-${PROJECT_NAME}")
add_dependencies("test-${PROJECT_NAME}"                         "test-${PROJECT_NAME}-executable")
add_dependencies("library-${PROJECT_NAME}-cmake-install"        "test-${PROJECT_NAME}")
add_dependencies("library-${PROJECT_NAME}-conan-export-testing" "library-${PROJECT_NAME}-cmake-install")
add_dependencies("package-test-${PROJECT_NAME}-conan-install"   "library-${PROJECT_NAME}-conan-export-testing")
add_dependencies("package-test-${PROJECT_NAME}-executable"      "package-test-${PROJECT_NAME}-conan-install")
add_dependencies("package-test-${PROJECT_NAME}"                 "package-test-${PROJECT_NAME}-executable")
add_dependencies("library-${PROJECT_NAME}-conan-export"         "package-test-${PROJECT_NAME}")
