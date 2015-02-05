###########################################################################
#
#  Library:   CTK
#
#  Copyright (c) Kitware Inc.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0.txt
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#
###########################################################################


#-----------------------------------------------------------------------------
# WARNING - No change should be required after this comment
#           when you are adding a new external project dependency.
#-----------------------------------------------------------------------------

#-----------------------------------------------------------------------------
# Make sure ${CTK_BINARY_DIR}/CTK-build/bin exists
# May be used by some external project to install libs 
if(NOT EXISTS ${CTK_BINARY_DIR}/CTK-build/bin)
  file(MAKE_DIRECTORY ${CTK_BINARY_DIR}/CTK-build/bin)
endif()

#-----------------------------------------------------------------------------
set(proj CTK)


#CTK_DEPENDENCIES
message(STATUS "CTK dependency: ${CTK_DEPENDENCIES} ")


ExternalProject_Add(${proj}
  ${${proj}_EP_ARGS}
  DOWNLOAD_COMMAND ""
  CMAKE_CACHE_ARGS
    -DCTK_SUPERBUILD:BOOL=OFF
    -DCTK_SUPERBUILD_BINARY_DIR:PATH=${CTK_BINARY_DIR}
	-DCMAKE_PREFIX_PATH:PATH=${CMAKE_PREFIX_PATH}
    -DCMAKE_C_COMPILER:FILEPATH=${CMAKE_C_COMPILER}
    -DCMAKE_CXX_COMPILER:FILEPATH=${CMAKE_CXX_COMPILER}
    -DCMAKE_CXX_FLAGS_INIT:STRING=${CMAKE_CXX_FLAGS_INIT}
    -DCMAKE_C_FLAGS_INIT:STRING=${CMAKE_C_FLAGS_INIT}
    -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
    -DCTK_QT_VERSION:STRING=${CTK_QT_VERSION}
    -DQT5_INSTALL_PREFIX:PATH=${QT5_INSTALL_PREFIX}
	-DPYTHON_EXECUTABLE:FILEPATH==${PYTHON_EXECUTABLE}
	-DPYTHON_INCLUDE_DIR:FILEPATH==${PYTHON_INCLUDE_DIR}
	-DPYTHON_LIBRARY:FILEPATH==${PYTHON_LIBRARY}	
  SOURCE_DIR ${CTK_SOURCE_DIR}
  BINARY_DIR ${CTK_BINARY_DIR}/CTK-build
  INSTALL_COMMAND ""
  DEPENDS
    ${CTK_DEPENDENCIES}
  STEP_TARGETS configure
  )

# This custom external project step forces the build and later
# steps to run whenever a top level build is done...
ExternalProject_Add_Step(${proj} forcebuild
  COMMAND ${CMAKE_COMMAND} -E echo_append ""
  COMMENT "Forcing build step for '${proj}'"
  DEPENDEES configure
  DEPENDERS build
  ALWAYS 1
  )
