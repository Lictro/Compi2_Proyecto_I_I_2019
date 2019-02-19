cmake_minimum_required (VERSION 2.6)
project (test_parser)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/")

set(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} -std=c++14")

# We use a custom lemon version
add_executable(lemon ../tools/lemon.c)

# Run re2c to generate the lexer
add_custom_command (
  OUTPUT decaf_lexer.cpp
  COMMAND re2c -o decaf_lexer.cpp ../../lexer.re
  MAIN_DEPENDENCY ../../lexer.re
  )
  
# Run lemon to generate the parser
add_custom_command (
  OUTPUT decaf_parser.cpp decaf_tokens.h
  COMMAND lemon -T$../../../tools/lempar.c -ddecaf_tokens.h -odecaf_parser.cpp ../../parser.y
  MAIN_DEPENDENCY ../../parser.y
  )

include_directories(${CMAKE_CURRENT_BINARY_DIR})
include_directories(${PROJECT_SOURCE_DIR})

add_executable(test_parser decaf_parser.cpp decaf_lexer.cpp test_parser.cpp)

enable_testing()
add_test(NAME test_parser
         COMMAND test_parser)