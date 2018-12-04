---
---
### cmake template
-   note: *DO NOT* include source header list! --> cause strange std macro not defined errors.
-   note: After using swig_add_library(Foo ...), a CMake target called '\_Foo' gets created.
-   note: source list needs to be compiled into obj!

```cmake
cmake_minimum_required (VERSION 3.8)
PROJECT (example)

FIND_PACKAGE(PythonInterp 3 REQUIRED)
FIND_PACKAGE(PythonLibs ${PYTHON_VERSION_STRING} EXACT)
INCLUDE_DIRECTORIES(${PYTHON_INCLUDE_PATH})
message("PYTHONLIBS_VERSION_STRING: ${PYTHONLIBS_VERSION_STRING}")

find_package(SWIG REQUIRED)
include(${SWIG_USE_FILE})

if(PYTHONLIBS_VERSION_STRING MATCHES "^2.*$" )
    set(CMAKE_SWIG_FLAGS -classic)
else()
    set(CMAKE_SWIG_FLAGS -py3)
endif()
message("CMAKE_SWIG_FLAGS: ${CMAKE_SWIG_FLAGS}")

set(CMAKE_CXX_STANDARD 11) # C++11...
set(CMAKE_CXX_STANDARD_REQUIRED ON) #...is required...
set(CMAKE_CXX_EXTENSIONS OFF) #...without compiler extensions like gnu++11

include_directories (${CMAKE_CURRENT_SOURCE_DIR})
set_source_files_properties (example.i PROPERTIES CPLUSPLUS ON)
swig_add_library(example TYPE SHARED LANGUAGE python SOURCES example.i example.cpp)
target_include_directories(_example ...)
target_compile_options(_example PRIVATE -Werror)
set_target_properties(_example ...)
swig_link_libraries(example ${PYTHON_LIBRARIES})
```
