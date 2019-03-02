cmake_minimum_required (VERSION 2.6)
project (decaf)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/")

set(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} -std=c++14")

# We use a custom lemon version
add_executable(lemon ${PROJECT_SOURCE_DIR}/tools/lemon.c)

# Run re2c to generate the lexer
add_custom_command (
  OUTPUT decaf_lexer.cpp
  COMMAND re2c -o decaf_lexer.cpp ${PROJECT_SOURCE_DIR}/lexer.re
  MAIN_DEPENDENCY ${PROJECT_SOURCE_DIR}/lexer.re
  )
  
# Run lemon to generate the parser
add_custom_command (
  OUTPUT decaf_parser.cpp decaf_tokens.h
  COMMAND lemon -T${PROJECT_SOURCE_DIR}/tools/lempar.c -ddecaf_tokens.h -odecaf_parser.cpp ${PROJECT_SOURCE_DIR}/parser.y
  MAIN_DEPENDENCY ${PROJECT_SOURCE_DIR}/parser.y
  )

# Run treec to generate the AST
add_custom_command (
  OUTPUT decaf_ast.cpp decaf_ast.h
  COMMAND treecc -o decaf_ast.cpp -h decaf_ast.h ${PROJECT_SOURCE_DIR}/ast.tc
  MAIN_DEPENDENCY ${PROJECT_SOURCE_DIR}/ast.tc
  )

include_directories(${CMAKE_CURRENT_BINARY_DIR})
include_directories(${PROJECT_SOURCE_DIR})
include_directories(${PROJECT_SOURCE_DIR}/../)
 
add_executable(${PROJECT_NAME} decaf_ast.cpp decaf_parser.cpp decaf_lexer.cpp ../main.cpp)

