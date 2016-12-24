/* Copyright 2015-2016 Whitewood Encryption Systems, Inc. */
#include "stdafx.h"
#include "logging.h"
#include "internal.h"
#include "wnr.h"
#include <assert.h>
#include <stddef.h>
#ifdef _WIN32
#include <io.h>
#else
#include <unistd.h>
#endif
#include <fcntl.h>
#include <string.h>
#include <stdarg.h>
#include <time.h>
#include <stdlib.h>


// TODO: implement "only show errors+" etc

static int *_fdesc = NULL;
static int _nfdesc = 0;
static int _minlvl = INFO;

int setup_logger(int *fdesc, int nfdesc, int minlvl)
{
    assert(nfdesc > 0);
    assert(minlvl >= 0 && minlvl < LOGGING_LEVEL_MAX);

	_fdesc =(int *) malloc(sizeof(int) * nfdesc);

    memcpy(_fdesc, fdesc, sizeof(int) * nfdesc);

    _nfdesc = nfdesc;

    _minlvl = minlvl;
    return WNR_ERROR_NONE;
}

int teardown_logger() {
    free(_fdesc);
    return WNR_ERROR_NONE;
}

void logerror(int level, const char *fmtstr, ...)
{
    va_list    lp;
    struct tm *timeinfo;
    time_t     rawtime;
    char      *lvlstr   = NULL;
    char      curtime[18] = {0};
    char      tmp[2048] = {0};
    char      logstr[1024] = {0};

    if (level <= _minlvl) {
        switch (level) {
            case INFO:
                lvlstr = "INFO";
                break;
            case WARNING:
                lvlstr = "WARNING";
                break;
            case LOG_ERROR:
                lvlstr = "ERROR";
                break;
            case CRITICAL:
                lvlstr = "CRITICAL";
                break;
            case DEBUG:
                lvlstr = "DEBUG";
                break;
            default:
                lvlstr = "UNKOWN";
        }

        va_start(lp, fmtstr);
        vsnprintf(logstr, 1024, fmtstr, lp);
        va_end(lp);

        time(&rawtime);

        timeinfo = localtime(&rawtime);


        strftime(curtime, 18, "%D %T", timeinfo);

        if (level == LOG_ERROR && errno != 0)
          sprintf(tmp, "%s %s (%d / %s): %s", curtime, lvlstr, errno, strerror(errno), logstr);
        else
          sprintf(tmp, "%s %s: %s", curtime, lvlstr, logstr);

        for (int i = 0; i < _nfdesc; i++) {
#ifndef WIN32
#pragma GCC diagnostic ignored "-Wunused-result"
            write(_fdesc[i], tmp, strlen(tmp));
#pragma GCC diagnostic pop
#endif
        }
    }
}
