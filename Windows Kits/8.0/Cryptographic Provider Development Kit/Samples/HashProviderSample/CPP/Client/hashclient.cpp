/*++

Abstract:
    Sample program for adding a new hash algorithm to CNG and using it.

    For lack of a better name this is called MD0 (imaginary)

Author:
    
--*/

#include <windows.h>
#include <stdio.h>
#include <bcrypt.h>
#include <bcrypt_provider.h>

#define NT_SUCCESS(Status)          (((NTSTATUS)(Status)) >= 0)

#define STATUS_UNSUCCESSFUL         ((NTSTATUS)0xC0000001L)

#define SAMPLE_HASH_PROVIDER_NAME   L"Sample Hash Provider"

static const BYTE rgbMsg[] = 
{
    0x61, 0x62, 0x63
};

static const BYTE rgbHmacKey[] =
{
    0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 
    0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b
};

void PrintBytes(
                IN BYTE     *pbPrintData,
                IN DWORD    cbDataLen)
{
    DWORD dwCount = 0;

    for(dwCount=0; dwCount < cbDataLen;dwCount++)
    {
        printf("0x%02x, ",pbPrintData[dwCount]);

        if(0 == (dwCount + 1 )%10) putchar('\n');
    }

}

void TestHashAlgorithm(
                IN BOOL    fHmac,
                IN LPCWSTR pszHashAlg)
{
    BCRYPT_ALG_HANDLE       hAlg                = NULL;
    BCRYPT_HASH_HANDLE      hHash               = NULL;
    NTSTATUS                status              = STATUS_UNSUCCESSFUL;
    DWORD                   cbData              = 0,
                            cbHash              = 0,
                            cbHashObject        = 0;
    PBYTE                   pbHashObject        = NULL;
    PBYTE                   pbHash              = NULL;

    //open an algorithm handle to the new provider
    if(!NT_SUCCESS(status = BCryptOpenAlgorithmProvider(
                                                &hAlg,
                                                pszHashAlg,
                                                SAMPLE_HASH_PROVIDER_NAME,
                                                fHmac ? BCRYPT_ALG_HANDLE_HMAC_FLAG : 0)))
    {
        wprintf(L"**** Error 0x%x returned by BCryptOpenAlgorithmProvider\n", status);
        goto Cleanup;
    }

    //calculate the size of the buffer to hold the hash object
    if(!NT_SUCCESS(status = BCryptGetProperty(
                                        hAlg, 
                                        BCRYPT_OBJECT_LENGTH, 
                                        (PBYTE)&cbHashObject, 
                                        sizeof(DWORD), 
                                        &cbData, 
                                        0)))
    {
        wprintf(L"**** Error 0x%x returned by BCryptGetProperty\n", status);
        goto Cleanup;
    }

    //allocate the hash object on the heap
    pbHashObject = (PBYTE)HeapAlloc (GetProcessHeap (), 0, cbHashObject);
    if(NULL == pbHashObject)
    {
        wprintf(L"**** memory allocation failed\n");
        goto Cleanup;
    }

   //calculate the length of the hash
    if(!NT_SUCCESS(status = BCryptGetProperty(
                                        hAlg, 
                                        BCRYPT_HASH_LENGTH, 
                                        (PBYTE)&cbHash, 
                                        sizeof(DWORD), 
                                        &cbData, 
                                        0)))
    {
        wprintf(L"**** Error 0x%x returned by BCryptGetProperty\n", status);
        goto Cleanup;
    }

    //allocate the hash buffer on the heap
    pbHash = (PBYTE)HeapAlloc (GetProcessHeap (), 0, cbHash);
    if(NULL == pbHash)
    {
        wprintf(L"**** memory allocation failed\n");
        goto Cleanup;
    }

    //create a hash
    if(!NT_SUCCESS(status = BCryptCreateHash(
                                        hAlg, 
                                        &hHash, 
                                        pbHashObject, 
                                        cbHashObject, 
                                        fHmac ? (PBYTE)rgbHmacKey : NULL, 
                                        fHmac ? (DWORD)sizeof(rgbHmacKey) : 0, 
                                        0)))
    {
        wprintf(L"**** Error 0x%x returned by BCryptCreateHash\n", status);
        goto Cleanup;
    }
    

    //hash some data
    if(!NT_SUCCESS(status = BCryptHashData(
                                        hHash,
                                        (PBYTE)rgbMsg,
                                        sizeof(rgbMsg),
                                        0)))
    {
        wprintf(L"**** Error 0x%x returned by BCryptHashData\n", status);
        goto Cleanup;
    }
    
    //close the hash
    if(!NT_SUCCESS(status = BCryptFinishHash(
                                        hHash, 
                                        pbHash, 
                                        cbHash, 
                                        0)))
    {
        wprintf(L"**** Error 0x%x returned by BCryptFinishHash\n", status);
        goto Cleanup;
    }

    PrintBytes(pbHash, cbHash);
    putchar('\n');

Cleanup:

    if(hAlg)
    {
        BCryptCloseAlgorithmProvider(hAlg,0);
    }

    if (hHash)    
    {
        BCryptDestroyHash(hHash);
    }

    if(pbHashObject)
    {
        HeapFree(GetProcessHeap(), 0, pbHashObject);
    }

    if(pbHash)
    {
        HeapFree(GetProcessHeap(), 0, pbHash);
    }
}


void __cdecl wmain(
                   int                      argc, 
                   __in_ecount(argc) LPWSTR *wargv)
{
    NTSTATUS                status              = STATUS_UNSUCCESSFUL;
    CRYPT_PROVIDER_REG      ProvReg             = {0};
    CRYPT_IMAGE_REG         ImageReg            = {0};
    CRYPT_INTERFACE_REG     InterfaceReg        = {0}, 
                            *pInterfaceReg      = {0};
    PWSTR                   FunctionsArray[2]   = {0}; 
    BOOL                    fProvider           = FALSE,
                            fFunction           = FALSE;

    UNREFERENCED_PARAMETER(argc);
    UNREFERENCED_PARAMETER(wargv);


    pInterfaceReg = &InterfaceReg;

    //functions supported by test provider
    FunctionsArray[0] = L"MD0";

    //populate data for hash interface
    InterfaceReg.dwInterface    = BCRYPT_HASH_INTERFACE;
    InterfaceReg.dwFlags        = 0;
    InterfaceReg.cFunctions     = 1;
    InterfaceReg.rgpszFunctions = FunctionsArray;

    ImageReg.pszImage           = L"hashprov.dll";  //provider dll
    ImageReg.cInterfaces        = 1;                //only one interface - hash
    ImageReg.rgpInterfaces      = &pInterfaceReg;
    
    ProvReg.pUM = &ImageReg;

    //register a new provider which supports the new algorithm.
    if(!NT_SUCCESS(status = BCryptRegisterProvider(
                                            SAMPLE_HASH_PROVIDER_NAME,
                                            0,
                                            &ProvReg)))
    {
        wprintf(L"**** Error 0x%x returned by BCryptRegisterProvider\n", status);
        goto Cleanup;
    } 

    fProvider = TRUE;

    //add the function (MD0) configuration node
    if(!NT_SUCCESS(status = BCryptAddContextFunctionProvider(
                                                    CRYPT_LOCAL,
                                                    NULL,
                                                    BCRYPT_HASH_INTERFACE,
                                                    L"MD0",
                                                    SAMPLE_HASH_PROVIDER_NAME,
                                                    CRYPT_PRIORITY_TOP)))
    {
        wprintf(L"**** Error 0x%x returned by BCryptAddContextFunctionProvider\n", status);
        goto Cleanup;
    } 

    fFunction = TRUE;

    wprintf(L"Hash data with MD0\n");
    TestHashAlgorithm(FALSE, L"MD0"); //hash 

    wprintf(L"Hmac data with MD0\n");
    TestHashAlgorithm(TRUE, L"MD0"); //hmac

Cleanup:

    //remove the function configuration node
    if(fFunction)
    {
        if(!NT_SUCCESS(status = BCryptConfigureContextFunction(
                                        CRYPT_LOCAL,
                                        NULL,
                                        BCRYPT_HASH_INTERFACE,
                                        L"MD0",
                                        NULL)))
        {
            wprintf(L"**** Error 0x%x returned by BCryptConfigureContextFunction\n", status);
        }

    }
    
    //remove provider from the system
    if(fProvider)
    {
        if(!NT_SUCCESS(status = BCryptUnregisterProvider(SAMPLE_HASH_PROVIDER_NAME)))
        {
            wprintf(L"**** Error 0x%x returned by BCryptUnregisterProvider\n", status);
        }

    }
}

