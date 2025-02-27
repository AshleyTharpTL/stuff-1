

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

conan_message(STATUS "Conan: Using autogenerated FindOpenEXR.cmake")
# Global approach
set(OpenEXR_FOUND 1)
set(OpenEXR_VERSION "2.5.3")

find_package_handle_standard_args(OpenEXR REQUIRED_VARS
                                  OpenEXR_VERSION VERSION_VAR OpenEXR_VERSION)
mark_as_advanced(OpenEXR_FOUND OpenEXR_VERSION)


set(OpenEXR_INCLUDE_DIRS "/home/duck/.conan/data/openexr/2.5.3/_/_/package/2805a5569cf93cb147878a90cd0b7f5dd229db3b/include/OpenEXR"
			"/home/duck/.conan/data/openexr/2.5.3/_/_/package/2805a5569cf93cb147878a90cd0b7f5dd229db3b/include")
set(OpenEXR_INCLUDE_DIR "/home/duck/.conan/data/openexr/2.5.3/_/_/package/2805a5569cf93cb147878a90cd0b7f5dd229db3b/include/OpenEXR;/home/duck/.conan/data/openexr/2.5.3/_/_/package/2805a5569cf93cb147878a90cd0b7f5dd229db3b/include")
set(OpenEXR_INCLUDES "/home/duck/.conan/data/openexr/2.5.3/_/_/package/2805a5569cf93cb147878a90cd0b7f5dd229db3b/include/OpenEXR"
			"/home/duck/.conan/data/openexr/2.5.3/_/_/package/2805a5569cf93cb147878a90cd0b7f5dd229db3b/include")
set(OpenEXR_RES_DIRS )
set(OpenEXR_DEFINITIONS )
set(OpenEXR_LINKER_FLAGS_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)
set(OpenEXR_COMPILE_DEFINITIONS )
set(OpenEXR_COMPILE_OPTIONS_LIST "" "")
set(OpenEXR_COMPILE_OPTIONS_C "")
set(OpenEXR_COMPILE_OPTIONS_CXX "")
set(OpenEXR_LIBRARIES_TARGETS "") # Will be filled later, if CMake 3
set(OpenEXR_LIBRARIES "") # Will be filled later
set(OpenEXR_LIBS "") # Same as OpenEXR_LIBRARIES
set(OpenEXR_SYSTEM_LIBS pthread stdc++)
set(OpenEXR_FRAMEWORK_DIRS )
set(OpenEXR_FRAMEWORKS )
set(OpenEXR_FRAMEWORKS_FOUND "") # Will be filled later
set(OpenEXR_BUILD_MODULES_PATHS )

conan_find_apple_frameworks(OpenEXR_FRAMEWORKS_FOUND "${OpenEXR_FRAMEWORKS}" "${OpenEXR_FRAMEWORK_DIRS}")

mark_as_advanced(OpenEXR_INCLUDE_DIRS
                 OpenEXR_INCLUDE_DIR
                 OpenEXR_INCLUDES
                 OpenEXR_DEFINITIONS
                 OpenEXR_LINKER_FLAGS_LIST
                 OpenEXR_COMPILE_DEFINITIONS
                 OpenEXR_COMPILE_OPTIONS_LIST
                 OpenEXR_LIBRARIES
                 OpenEXR_LIBS
                 OpenEXR_LIBRARIES_TARGETS)

# Find the real .lib/.a and add them to OpenEXR_LIBS and OpenEXR_LIBRARY_LIST
set(OpenEXR_LIBRARY_LIST IlmImf-2_5 IlmImfUtil-2_5 IlmThread-2_5 Imath-2_5 Half-2_5 IexMath-2_5 Iex-2_5)
set(OpenEXR_LIB_DIRS "/home/duck/.conan/data/openexr/2.5.3/_/_/package/2805a5569cf93cb147878a90cd0b7f5dd229db3b/lib")

# Gather all the libraries that should be linked to the targets (do not touch existing variables):
set(_OpenEXR_DEPENDENCIES "${OpenEXR_FRAMEWORKS_FOUND} ${OpenEXR_SYSTEM_LIBS} ZLIB::ZLIB")

conan_package_library_targets("${OpenEXR_LIBRARY_LIST}"  # libraries
                              "${OpenEXR_LIB_DIRS}"      # package_libdir
                              "${_OpenEXR_DEPENDENCIES}"  # deps
                              OpenEXR_LIBRARIES            # out_libraries
                              OpenEXR_LIBRARIES_TARGETS    # out_libraries_targets
                              ""                          # build_type
                              "OpenEXR")                                      # package_name

set(OpenEXR_LIBS ${OpenEXR_LIBRARIES})

foreach(_FRAMEWORK ${OpenEXR_FRAMEWORKS_FOUND})
    list(APPEND OpenEXR_LIBRARIES_TARGETS ${_FRAMEWORK})
    list(APPEND OpenEXR_LIBRARIES ${_FRAMEWORK})
endforeach()

foreach(_SYSTEM_LIB ${OpenEXR_SYSTEM_LIBS})
    list(APPEND OpenEXR_LIBRARIES_TARGETS ${_SYSTEM_LIB})
    list(APPEND OpenEXR_LIBRARIES ${_SYSTEM_LIB})
endforeach()

# We need to add our requirements too
set(OpenEXR_LIBRARIES_TARGETS "${OpenEXR_LIBRARIES_TARGETS};ZLIB::ZLIB")
set(OpenEXR_LIBRARIES "${OpenEXR_LIBRARIES};ZLIB::ZLIB")

set(CMAKE_MODULE_PATH "/home/duck/.conan/data/openexr/2.5.3/_/_/package/2805a5569cf93cb147878a90cd0b7f5dd229db3b/" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "/home/duck/.conan/data/openexr/2.5.3/_/_/package/2805a5569cf93cb147878a90cd0b7f5dd229db3b/" ${CMAKE_PREFIX_PATH})

foreach(_BUILD_MODULE_PATH ${OpenEXR_BUILD_MODULES_PATHS})
    include(${_BUILD_MODULE_PATH})
endforeach()

if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
    # Target approach
    if(NOT TARGET OpenEXR::OpenEXR)
        add_library(OpenEXR::OpenEXR INTERFACE IMPORTED)
        if(OpenEXR_INCLUDE_DIRS)
            set_target_properties(OpenEXR::OpenEXR PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
                                  "${OpenEXR_INCLUDE_DIRS}")
        endif()
        set_property(TARGET OpenEXR::OpenEXR PROPERTY INTERFACE_LINK_LIBRARIES
                     "${OpenEXR_LIBRARIES_TARGETS};${OpenEXR_LINKER_FLAGS_LIST}")
        set_property(TARGET OpenEXR::OpenEXR PROPERTY INTERFACE_COMPILE_DEFINITIONS
                     ${OpenEXR_COMPILE_DEFINITIONS})
        set_property(TARGET OpenEXR::OpenEXR PROPERTY INTERFACE_COMPILE_OPTIONS
                     "${OpenEXR_COMPILE_OPTIONS_LIST}")
        
        # Library dependencies
        include(CMakeFindDependencyMacro)

        if(NOT ZLIB_FOUND)
            find_dependency(ZLIB REQUIRED)
        else()
            message(STATUS "Dependency ZLIB already found")
        endif()

    endif()
endif()
