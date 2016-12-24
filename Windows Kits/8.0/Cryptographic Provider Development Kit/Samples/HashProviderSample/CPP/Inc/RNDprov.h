
#ifndef _NETRANDPROV_H_
#define _NETRANDPROV_H_


#ifdef __cplusplus
extern "C"
{
#endif

#include <malloc.h>
#include <windows.h>

	//helper macros
#define MALLOC(X)   HeapAlloc(GetProcessHeap(), HEAP_ZERO_MEMORY, (X));

#define FREE(X)     { if(X) { HeapFree(GetProcessHeap(), 0, X); X = NULL ; } }
#define WERNG_PROVIDER_NAME L"NetRand RNG Provider"
#include <bcrypt.h>
#include <bcrypt_provider.h>
}
//
#endif //_NETRANDPROV_H_
