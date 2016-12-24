// The following ifdef block is the standard way of creating macros which make exporting 
// from a DLL simpler. All files within this DLL are compiled with the CNGPROVIDER_EXPORTS
// symbol defined on the command line. This symbol should not be defined on any project
// that uses this DLL. This way any other project whose source files include this file see 
// CNGPROVIDER_API functions as being imported from a DLL, whereas this DLL sees symbols
// defined with this macro as being exported.
#ifdef CNGPROVIDER_EXPORTS
#define CNGPROVIDER_API __declspec(dllexport)
#else
#define CNGPROVIDER_API __declspec(dllimport)
#endif

// This class is exported from the CNGProvider.dll
class CNGPROVIDER_API CCNGProvider {
public:
	CCNGProvider(void);
	// TODO: add your methods here.
};

extern CNGPROVIDER_API int nCNGProvider;

CNGPROVIDER_API int fnCNGProvider(void);
