
#ifndef SDV_PRE_RUN
#include "..\..\sdv-pre-results.h"
#if (purekmdfdriver_SDV_RESULT == SDV_NA && nonpnpkmdfdriver_SDV_RESULT==SDV_FAILED && staticbus_SDV_RESULT==SDV_FAILED)
   #define SDV_HARNESS SDV_HARNESS_PNP_IO_REQUESTS
#else
  #pragma message("SDV_NA")  
#endif
#else
#pragma message("purekmdfdriver==SDV_NA")
#pragma message("nonpnpkmdfdriver==SDV_FAILED")
#pragma message("staticbus==SDV_FAILED")
#endif