cmake_minimum_required (VERSION 3.1)
set (CMAKE_CXX_STANDARD 14)
set (CMAKE_CXX_STANDARD_REQUIRED TRUE)

# define a macro that helps defining an option

# project name
set(PROJECT_NAME "DaiMyshaGenericUtils")

project (${PROJECT_NAME})

# setup version numbers
set(VERSION_MAJOR 0)
set(VERSION_MINOR 1)
set(VERSION_PATCH 0)

cmake_policy(SET CMP0074 NEW)

# add the  header path
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/include ${CMAKE_CURRENT_SOURCE_DIR}/src)

set(LIBS "")

set(DEFINES "")
set(WARNING "-Wall")
set(CMAKE_CXX_FLAGS "${DEFINES} ${WARNING} ${FLAGS}")

set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/bin)
set(LIB_INSTALL_DIR ${CMAKE_CURRENT_SOURCE_DIR}/lib)

set(CMAKE_SHARED_LIBRARY_PREFIX )

set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/modules;${CMAKE_SOURCE_DIR}")

#option(USEDEBUG "Debug mode" OFF)

#move that to a util file too ?
if (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")	
	#Remove some unneccessary exceptions on visual studio
	add_compile_options(/EHsc)    #Exception mode standard + C automatic noexcept
	add_compile_options(/wd4061)  #enumerator XX in switch is not explicitly handled by a case label
	add_compile_options(/wd4100)  #unreferenced formal parameter
	add_compile_options(/wd4242)  #convertion from type1 to type2: possible loss of data
	add_compile_options(/wd4244)  #convertion from type1 to type2: possible loss of data
	add_compile_options(/wd4263)  #member function does not override any base class virtual member function
	add_compile_options(/wd4264)  #no override available for virtual member function from base 'XXX'; function is hidden
	add_compile_options(/wd4267)  #argument: convertion from size_t to type, possible loss of data
	add_compile_options(/wd4365)  #signed/unsigned mismatch with size_t
	add_compile_options(/wd4464)  #relative include path contains '..'
	add_compile_options(/wd4477)  #sprintf format string %u with size_t
	add_compile_options(/wd4514)  #Unreferenced inline function has been removed
	add_compile_options(/wd4571)  #catch semantics have changed since VS 7.1 (happens in xlocale)
	add_compile_options(/wd4577)  #noexcept used with no exception handling mode specified
	add_compile_options(/wd4625)  #copy constructor implicitely defined as deleted
	add_compile_options(/wd4626)  #assignment operator implicitely defined as deleted
	add_compile_options(/wd4668)  #'_WIN32_WINNT_WIN10_RS1' is not defined as a preprocessor macro (happens in winioctl.h)
	add_compile_options(/wd4702)  #unreachable code
	add_compile_options(/wd4710)  #function not inlined
	add_compile_options(/wd4738)  #storing 32-bit float result in memory, possible loss of performance
	add_compile_options(/wd4774)  #format string expected in argument 3 is not a string literal (happens in swprintf_s)
	add_compile_options(/wd4777)  #sprintf format string %u received size_t
	add_compile_options(/wd4820)  #padding added
	add_compile_options(/wd5026)  #move constructor operator implicitely defined as deleted
	add_compile_options(/wd5027)  #move assignment operator implicitely defined as deleted
	add_compile_options(/wd5039)  #pointer or reference to potentially throwing function passed to extern C function under -EHc (happens in WinBase.h)
	add_compile_options(/wd5045)  #compiler will insert Spectre mitigation if /Qspectre is specified
	add_compile_options(/wd5219)  #implicit convertion
	add_compile_options(/wd6328)  #Size mismatch (removed if if needed)
	add_compile_options(/wd26812) #enum is unscoped
	add_compile_options(/wd26819) #unannotated
	add_definitions(-D_CRT_SECURE_NO_WARNINGS)
endif()

if(USEDEBUG)
  add_definitions(-DUSEDEBUG)
endif()


list(APPEND LIBS
	${LIBS}
)

set(FILES_HEADER
	include/dmUtils/DynamicBitSet.hpp
	include/dmUtils/FixedSizeList.hpp
	include/dmUtils/RessourceVector.hpp
	include/dmUtils/maths.hpp
	
	unittest/test_utils.hpp
	unittest/dmUtilsUnitTests.hpp
)

set(FILES_SRC
	unittest/dmUtilsUnitTests.cpp
	unittest/test_utils.cpp
	unittest/test_fixedSizeList.cpp
	unittest/test_dynamicBitSet.cpp
	unittest/test_ressourcevector.cpp
)

add_executable(${PROJECT_NAME} ${FILES_HEADER} ${FILES_SRC})
target_link_libraries(${PROJECT_NAME} ${LIBS})


