/* Copyright 2015-2016 Whitewood Encryption Systems, Inc. */

#ifndef LOGGING_H_
#define LOGGING_H_

enum  {
  CRITICAL = 0,
  LOG_ERROR,
  WARNING,
  INFO,
  DEBUG,

  LOGGING_LEVEL_MAX
};

#ifdef __cplusplus
extern "C" {
#endif

int setup_logger(int *fdesc, int nfdesc, int minlvl);
int teardown_logger();
void logerror(int level, const char *fmtstr, ...);

#ifdef __cplusplus
}
#endif
#endif
