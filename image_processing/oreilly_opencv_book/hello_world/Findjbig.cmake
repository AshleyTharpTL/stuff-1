

function(conan_message MESSAGE_OUTPUT)
    if(NOT CONAN_CMAKE_SILENT_OUTPUT)
        message(${ARGV${0}})
    endif()
endfunction()


macro(conan_find_apple_frameworks FRAMEWORKS_FOUND FRAMEWORKS FRAMEWORKS_DIRS)
    if(APPLE)
        foreach(_FRAMEWORK ${FRAMEWORKS})
            # https://cmake.org/pipermail/cmake-developers/2017-August/030199.html
            find_library(CONAN_FRAMEWORK_${_FRAMEWORK}_FOUND NAME ${_FRAMEWORK} PATHS ${FRAMEWORKS_DIRS} CMAKE_FIND_ROOT_PATH_BOTH)
            if(CONAN_FRAMEWORK_${_FRAMEWORK}_FOUND)
                list(APPEND ${FRAMEWORKS_FOUND} ${CONAN_FRAMEWORK_${_FRAMEWORK}_FOUND})
            else()
                message(FATAL_ERROR "Framework library ${_FRAMEWORK} not found in paths: ${FRAMEWORKS_DIRS}")
            endif()
        endforeach()
    endif()
endmacro()


function(conan_package_library_targets libraries package_libdir deps out_libraries out_libraries_target build_type package_name)
    unset(_CONAN_ACTUAL_TARGETS CACHE)
    unset(_CONAN_FOUND_SYSTEM_LIBS CACHE)
    foreach(_LIBRARY_NAME ${libraries})
        find_library(CONAN_FOUND_LIBRARY NAME ${_LIBRARY_NAME} PATHS ${package_libdir}
                     NO_DEFAULT_PATH NO_CMAKE_FIND_ROOT_PATH)
        if(CONAN_FOUND_LIBRARY)
            conan_message(STATUS "Library ${_LIBRARY_NAME} found ${CONAN_FOUND_LIBRARY}")
            list(APPEND _out_libraries ${CONAN_FOUND_LIBRARY})
            if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
                # Create a micro-target for each lib/a found
                set(_LIB_NAME CONAN_LIB::${package_name}_${_LIBRARY_NAME}${build_type})
                if(NOT TARGET ${_LIB_NAME})
                    # Create a micro-target for each lib/a found
                    add_library(${_LIB_NAME} UNKNOWN IMPORTED)
                    set_target_properties(${_LIB_NAME} PROPERTIES IMPORTED_LOCATION ${CONAN_FOUND_LIBRARY})
                    set(_CONAN_ACTUAL_TARGETS ${_CONAN_ACTUAL_TARGETS} ${_LIB_NAME})
                else()
                    conan_message(STATUS "Skipping already existing target: ${_LIB_NAME}")
                endif()
                list(APPEND _out_libraries_target ${_LIB_NAME})
            endif()
            conan_message(STATUS "Found: ${CONAN_FOUND_LIBRARY}")
        else()
            conan_message(STATUS "Library ${_LIBRARY_NAME} not found in package, might be system one")
            list(APPEND _out_libraries_target ${_LIBRARY_NAME})
            list(APPEND _out_libraries ${_LIBRARY_NAME})
            set(_CONAN_FOUND_SYSTEM_LIBS "${_CONAN_FOUND_SYSTEM_LIBS};${_LIBRARY_NAME}")
        endif()
        unset(CONAN_FOUND_LIBRARY CACHE)
    endforeach()

    if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
        # Add all dependencies to all targets
        string(REPLACE " " ";" deps_list "${deps}")
        foreach(_CONAN_ACTUAL_TARGET ${_CONAN_ACTUAL_TARGETS})
            set_property(TARGET ${_CONAN_ACTUAL_TARGET} PROPERTY INTERFACE_LINK_LIBRARIES "${_CONAN_FOUND_SYSTEM_LIBS};${deps_list}")
        endforeach()
    endif()

    set(${out_libraries} ${_out_libraries} PARENT_SCOPE)
    set(${out_libraries_target} ${_out_libraries_target} PARENT_SCOPE)
endfunction()


include(FindPackageHandleStandardArgs)

conan_message(STATUS "Conan: Using autogenerated Findjbig.cmake")
# Global approach
set(jbig_FOUND 1)
set(jbig_VERSION "20160605")

find_package_handle_standard_args(jbig REQUIRED_VARS
                                  jbig_VERSION VERSION_VAR jbig_VERSION)
mark_as_advanced(jbig_FOUND jbig_VERSION)


set(jbig_INCLUDE_DIRS "/home/duck/.conan/data/jbig/20160605/_/_/package/d8fff784e71b40316e752103c83b4698d094b5e3/include")
set(jbig_INCLUDE_DIR "/home/duck/.conan/data/jbig/20160605/_/_/package/d8fff784e71b40316e752103c83b4698d094b5e3/include")
set(jbig_INCLUDES "/home/duck/.conan/data/jbig/20160605/_/_/package/d8fff784e71b40316e752103c83b4698d094b5e3/include")
set(jbig_RES_DIRS )
set(jbig_DEFINITIONS )
set(jbig_LINKER_FLAGS_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)
set(jbig_COMPILE_DEFINITIONS )
set(jbig_COMPILE_OPTIONS_LIST "" "")
set(jbig_COMPILE_OPTIONS_C "")
set(jbig_COMPILE_OPTIONS_CXX "")
set(jbig_LIBRARIES_TARGETS "") # Will be filled later, if CMake 3
set(jbig_LIBRARIES "") # Will be filled later
set(jbig_LIBS "") # Same as jbig_LIBRARIES
set(jbig_SYSTEM_LIBS )
set(jbig_FRAMEWORK_DIRS )
set(jbig_FRAMEWORKS )
set(jbig_FRAMEWORKS_FOUND "") # Will be filled later
set(jbig_BUILD_MODULES_PATHS )

conan_find_apple_frameworks(jbig_FRAMEWORKS_FOUND "${jbig_FRAMEWORKS}" "${jbig_FRAMEWORK_DIRS}")

mark_as_advanced(jbig_INCLUDE_DIRS
                 jbig_INCLUDE_DIR
                 jbig_INCLUDES
                 jbig_DEFINITIONS
                 jbig_LINKER_FLAGS_LIST
                 jbig_COMPILE_DEFINITIONS
                 jbig_COMPILE_OPTIONS_LIST
                 jbig_LIBRARIES
                 jbig_LIBS
                 jbig_LIBRARIES_TARGETS)

# Find the real .lib/.a and add them to jbig_LIBS and jbig_LIBRARY_LIST
set(jbig_LIBRARY_LIST jbig)
set(jbig_LIB_DIRS "/home/duck/.conan/data/jbig/20160605/_/_/package/d8fff784e71b40316e752103c83b4698d094b5e3/lib")

# Gather all the libraries that should be linked to the targets (do not touch existing variables):
set(_jbig_DEPENDENCIES "${jbig_FRAMEWORKS_FOUND} ${jbig_SYSTEM_LIBS} ")

conan_package_library_targets("${jbig_LIBRARY_LIST}"  # libraries
                              "${jbig_LIB_DIRS}"      # package_libdir
                              "${_jbig_DEPENDENCIES}"  # deps
                              jbig_LIBRARIES            # out_libraries
                              jbig_LIBRARIES_TARGETS    # out_libraries_targets
                              ""                          # build_type
                              "jbig")                                      # package_name

set(jbig_LIBS ${jbig_LIBRARIES})

foreach(_FRAMEWORK ${jbig_FRAMEWORKS_FOUND})
    list(APPEND jbig_LIBRARIES_TARGETS ${_FRAMEWORK})
    list(APPEND jbig_LIBRARIES ${_FRAMEWORK})
endforeach()

foreach(_SYSTEM_LIB ${jbig_SYSTEM_LIBS})
    list(APPEND jbig_LIBRARIES_TARGETS ${_SYSTEM_LIB})
    list(APPEND jbig_LIBRARIES ${_SYSTEM_LIB})
endforeach()

# We need to add our requirements too
set(jbig_LIBRARIES_TARGETS "${jbig_LIBRARIES_TARGETS};")
set(jbig_LIBRARIES "${jbig_LIBRARIES};")

set(CMAKE_MODULE_PATH "/home/duck/.conan/data/jbig/20160605/_/_/package/d8fff784e71b40316e752103c83b4698d094b5e3/" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "/home/duck/.conan/data/jbig/20160605/_/_/package/d8fff784e71b40316e752103c83b4698d094b5e3/" ${CMAKE_PREFIX_PATH})

foreach(_BUILD_MODULE_PATH ${jbig_BUILD_MODULES_PATHS})
    include(${_BUILD_MODULE_PATH})
endforeach()

if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
    # Target approach
    if(NOT TARGET jbig::jbig)
        add_library(jbig::jbig INTERFACE IMPORTED)
        if(jbig_INCLUDE_DIRS)
            set_target_properties(jbig::jbig PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
                                  "${jbig_INCLUDE_DIRS}")
        endif()
        set_property(TARGET jbig::jbig PROPERTY INTERFACE_LINK_LIBRARIES
                     "${jbig_LIBRARIES_TARGETS};${jbig_LINKER_FLAGS_LIST}")
        set_property(TARGET jbig::jbig PROPERTY INTERFACE_COMPILE_DEFINITIONS
                     ${jbig_COMPILE_DEFINITIONS})
        set_property(TARGET jbig::jbig PROPERTY INTERFACE_COMPILE_OPTIONS
                     "${jbig_COMPILE_OPTIONS_LIST}")
        
    endif()
endif()
