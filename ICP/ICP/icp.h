//
// MATLAB Compiler: 8.1 (R2020b)
// Date: Wed Apr 13 21:11:33 2022
// Arguments: "-B""macro_default""-W""cpplib:icp""-T""link:lib""icp.m""-C"
//

#ifndef icp_h
#define icp_h 1

#if defined(__cplusplus) && !defined(mclmcrrt_h) && defined(__linux__)
#  pragma implementation "mclmcrrt.h"
#endif
#include "mclmcrrt.h"
#include "mclcppclass.h"
#ifdef __cplusplus
extern "C" { // sbcheck:ok:extern_c
#endif

/* This symbol is defined in shared libraries. Define it here
 * (to nothing) in case this isn't a shared library. 
 */
#ifndef LIB_icp_C_API 
#define LIB_icp_C_API /* No special import/export declaration */
#endif

/* GENERAL LIBRARY FUNCTIONS -- START */

extern LIB_icp_C_API 
bool MW_CALL_CONV icpInitializeWithHandlers(
       mclOutputHandlerFcn error_handler, 
       mclOutputHandlerFcn print_handler);

extern LIB_icp_C_API 
bool MW_CALL_CONV icpInitialize(void);

extern LIB_icp_C_API 
void MW_CALL_CONV icpTerminate(void);

extern LIB_icp_C_API 
void MW_CALL_CONV icpPrintStackTrace(void);

/* GENERAL LIBRARY FUNCTIONS -- END */

/* C INTERFACE -- MLX WRAPPERS FOR USER-DEFINED MATLAB FUNCTIONS -- START */

extern LIB_icp_C_API 
bool MW_CALL_CONV mlxIcp(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[]);

/* C INTERFACE -- MLX WRAPPERS FOR USER-DEFINED MATLAB FUNCTIONS -- END */

#ifdef __cplusplus
}
#endif


/* C++ INTERFACE -- WRAPPERS FOR USER-DEFINED MATLAB FUNCTIONS -- START */

#ifdef __cplusplus

/* On Windows, use __declspec to control the exported API */
#if defined(_MSC_VER) || defined(__MINGW64__)

#ifdef EXPORTING_icp
#define PUBLIC_icp_CPP_API __declspec(dllexport)
#else
#define PUBLIC_icp_CPP_API __declspec(dllimport)
#endif

#define LIB_icp_CPP_API PUBLIC_icp_CPP_API

#else

#if !defined(LIB_icp_CPP_API)
#if defined(LIB_icp_C_API)
#define LIB_icp_CPP_API LIB_icp_C_API
#else
#define LIB_icp_CPP_API /* empty! */ 
#endif
#endif

#endif

extern LIB_icp_CPP_API void MW_CALL_CONV icp(const mwArray& name1, const mwArray& name2);

/* C++ INTERFACE -- WRAPPERS FOR USER-DEFINED MATLAB FUNCTIONS -- END */
#endif

#endif
