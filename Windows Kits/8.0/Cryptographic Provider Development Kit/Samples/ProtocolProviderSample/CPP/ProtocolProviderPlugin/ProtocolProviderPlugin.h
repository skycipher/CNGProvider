/** @file ProtocolProviderPlugin.h
  * @brief Contains constant definitions, macros, helper function prototypes, and strucure definitions
  *		   for most of the files included in ProtocolProviderPlugin.dll. If not here, then will most likely
  *		   be in MasterKey.h
**/

/// My defines ///////////////////////////////////////

// Memory allocation macros
#define MALLOC(X)   HeapAlloc(GetProcessHeap(), HEAP_ZERO_MEMORY, (X));
#define FREE(X)     { if(X) { HeapFree(GetProcessHeap(), 0, X); X = NULL ; } }

#define PROTOCOL_PROVIDER_NAME (L"Protocol Provider Plugin")


#define SSL3_MASTERKEY_LENGTH						48
#define BITS_IN_A_BYTE								8

// Cipher Suite Info
#define CIPHER_SUITE_NAME							L"TLS_RSA_WITH_RC2_CBC_40_MD5"		  // Cipher Suite Name
#define CIPHER_SUITE_CODE							0xFFF6								  // Cipher Suite Code (Experimental)
#define BASE_CIPHER_SUITE_CODE						0xFFF6									  // Base Cipher Suite Code
#define CIPHER_SUITE_KEY_LENGTH						5									  // Cipher Suite Key Length
#define CIPHER_BIT_LENGTH							40									  // Cipher Suite Key Length (in bits)
#define CIPHER_SUITE_HASH							L"MD5"							     
#define MIN_EXCHANGE_LEN							512
#define MAX_EXCHANGE_LEN							16384

// defines for packets.cpp
#define MAX_PACKET_SIZE								0x4000
#define SSL3_RECORD_HEADER_LENGTH					5
#define MD5_LENGTH									16
#define SHA1_LENGTH									20
#define MAC_LENGTH									16
#define BLOCK_LENGTH								8

// defines for hash.cpp
#define CLIENT_FINISHED_LABEL			"client finished"
#define CLIENT_FINISHED_LABEL_SIZE		15
#define SERVER_FINISHED_LABEL			"server finished"
#define SERVER_FINISHED_LABEL_SIZE		15

// defines for packets.cpp
#define MAC_BUFFER_2_SIZE (sizeof(ULONGLONG) + 1 + 2 + 2)

// Types of handles
#define TYPE_CUSTOM_PROTOCOL_PROVIDER		0x1
#define TYPE_KEY_OBJECT						0x2
#define TYPE_HASH_OBJECT					0x3
#define TYPE_MASTERKEY_OBJECT				0x4
#define TYPE_SESSION_KEY_OBJECT				0x5
#define TYPE_HANDSHAKE_HASH_OBJECT			0x6

// Structure Definitions
typedef struct _CUSTOM_PROTOCOL_PROVIDER {
	DWORD cbLength;
	DWORD dwHandleType;

    NCRYPT_PROV_HANDLE ncrypt_prov_handle;

	BCRYPT_ALG_HANDLE  sha1_alg_handle;
	DWORD			   sha1_obj_length;

	BCRYPT_ALG_HANDLE  md5_alg_handle;
	DWORD			   md5_obj_length;

	BCRYPT_ALG_HANDLE  md5_hmac_alg_handle;
	DWORD			   md5_hmac_obj_length;

	BCRYPT_ALG_HANDLE  sha1_hmac_alg_handle;
	DWORD			   sha1_hmac_obj_length;

	BCRYPT_ALG_HANDLE  rc2_alg_handle;
	DWORD			   rc2_obj_length;
	DWORD			   rc2_key_obj_length;

} CUSTOM_PROTOCOL_PROVIDER;
typedef CUSTOM_PROTOCOL_PROVIDER* P_CUSTOM_PROTOCOL_PROVIDER;

typedef struct _HASH_OBJECT {
	DWORD cbLength;
	DWORD dwHandleType;

	NCRYPT_HASH_HANDLE ncrypt_hash_handle;
} HASH_OBJECT;
typedef HASH_OBJECT* P_HASH_OBJECT;

typedef struct _KEY_OBJECT {
	DWORD cbLength;
	DWORD dwHandleType;

	NCRYPT_KEY_HANDLE ncrypt_key_handle;
} KEY_OBJECT;
typedef KEY_OBJECT* P_KEY_OBJECT;

typedef struct _SESSION_KEY_OBJECT {
	DWORD cbLength;
	DWORD dwHandleType;

	BCRYPT_KEY_HANDLE bcrypt_key_handle;

	BYTE pbMac[MD5_LENGTH];

	PBYTE pbKeyObjectBuffer;
} SESSION_KEY_OBJECT;
typedef SESSION_KEY_OBJECT* P_SESSION_KEY_OBJECT;

typedef struct _HANDSHAKE_HASH_OBJECT {
	DWORD cbLength;
	DWORD dwHandleType;

	BCRYPT_HASH_HANDLE hMD5;
	PBYTE pbMD5ObjectBuffer;
	DWORD cbMD5ObjectBuffer;

	BCRYPT_HASH_HANDLE hSHA1;
	PBYTE pbSHA1ObjectBuffer;
	DWORD cbSHA1ObjectBuffer;
} HANDSHAKE_HASH_OBJECT;
typedef HANDSHAKE_HASH_OBJECT* P_HANDSHAKE_HASH_OBJECT;

#define MASTERKEY_SERVER_FLAG 0x1
#define MASTERKEY_CLIENT_FLAG 0x2
typedef struct _MASTERKEY_OBJECT {
	DWORD cbLength;
	DWORD dwHandleType;

	BYTE pbMasterKey[SSL3_MASTERKEY_LENGTH];
	DWORD dwClientOrServer;
} MASTERKEY_OBJECT;
typedef MASTERKEY_OBJECT* P_MASTERKEY_OBJECT;

typedef struct _GENERIC_OBJECT {
	DWORD cbLength;
	DWORD dwHandleType;
} GENERIC_OBJECT;
typedef GENERIC_OBJECT* P_GENERIC_OBJECT;

// Macros for Provider handle to Provider structure conversion
#define PROVIDER_TO_HANDLE(provider)		((NCRYPT_PROV_HANDLE)provider)
#define KEY_TO_HANDLE(key)					((NCRYPT_KEY_HANDLE)key)
#define HANDLE_TO_GENERIC(handle)			((P_GENERIC_OBJECT)handle)
#define HANDLE_TO_PROVIDER(handle)			((P_CUSTOM_PROTOCOL_PROVIDER)handle)
#define HANDLE_TO_KEY(handle)				((P_KEY_OBJECT)handle)
#define HANDLE_TO_MASTERKEY(handle)			((P_MASTERKEY_OBJECT)handle)
#define HANDLE_TO_SESSION_KEY(handle)		((P_SESSION_KEY_OBJECT)handle)
#define HANDLE_TO_HANDSHAKE_HASH(handle)	((P_HANDSHAKE_HASH_OBJECT)handle)


#define MAX_CIPHER_SUITE_COUNT		1
typedef struct _ENUM_CIPHER_SUITE_STATE
{
    DWORD Index;
    DWORD SuiteCount;
    NCRYPT_SSL_CIPHER_SUITE SuiteList[MAX_CIPHER_SUITE_COUNT];
} ENUM_CIPHER_SUITE_STATE;


/** @macro CHECK_STATUS
  * @brief Used in many functions to test error codes with NT_SUCCESS, and if there is an error
  *		   it will perform cleanup. 
  *
  *		   NOTE: Any function using this macro must have a local cleanup label.
  *
  * @param Status:	The SECURITY_STATUS error code to check
  **/
#define CHECK_STATUS(Status)	if(!NT_SUCCESS(Status)) goto cleanup;

/** @macro CHECK_POINTER
  * @brief Will fail if a pointer is null
  **/
#define CHECK_POINTER(pointer)	if(!pointer) { Status = NTE_FAIL; goto cleanup; }


#ifndef NTSTATUS
typedef LONG NTSTATUS, *PNSTATUS;
#endif

#ifndef NT_SUCCESS
#define NT_SUCCESS(status) (status >= 0)
#endif


#ifndef STATUS_SUCCESS
#define STATUS_SUCCESS                   ((NTSTATUS)0x00000000L)
#define STATUS_NOT_SUPPORTED             ((NTSTATUS)0xC00000BBL)
#define STATUS_UNSUCCESSFUL              ((NTSTATUS)0xC0000001L)
#define STATUS_HMAC_NOT_SUPPORTED        ((NTSTATUS)0xC000A001L)
#define STATUS_BUFFER_TOO_SMALL          ((NTSTATUS)0xC0000023L)
#define STATUS_NOT_IMPLEMENTED           ((NTSTATUS)0xC0000002L)
#endif



// Helper function prototypes
P_KEY_OBJECT
WINAPI
newKeyObject();

SECURITY_STATUS
WINAPI
validateKeyHandle(NCRYPT_KEY_HANDLE hKey);

SECURITY_STATUS
WINAPI
validateProviderHandle(NCRYPT_PROV_HANDLE hProv);



