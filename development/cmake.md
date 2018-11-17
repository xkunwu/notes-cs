## How to structure your project
```text
- project
  - .gitignore
  - README.md
  - LICENCE.md
  - CMakeLists.txt
  - cmake
    - FindSomeLib.cmake
  - include
    - project
      - lib.hpp
  - src
    - CMakeLists.txt
    - lib.cpp
  - apps
    - CMakeLists.txt
    - app.cpp
  - tests
    - testlib.cpp
  - docs
    - Doxyfile.in
  - extern
    - googletest
  - scripts
    - helper.py
```

### How to view CMake cache variables
```
-L[A][H]: List non-advanced cached variables
    -A: advanced variables
    -H: help documentation
-N: View mode only

cmake -L -N
cmake -LAH -N
```
