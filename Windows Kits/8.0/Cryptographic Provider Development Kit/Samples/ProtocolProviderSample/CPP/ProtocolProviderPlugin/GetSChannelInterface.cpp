/** @file GetSChannelInterface.cpp
  * @brief Contains the implementation of the function SslGetSChannelInterface as well
  *        as the static instance of the function table
**/

#include "stdafx.h"
#include "ProtocolProviderPlugin.h"

// Static Instance of Function Table
static NCRYPT_SSL_FUNCTION_TABLE prot_provider_table = 
{
NCRYPT_SSL_INTERFACE_VERSION,
SslComputeClientAuthHash,
SslComputeEapKeyBlock,
SslComputeFinishedHash,
SslCreateEphemeralKey,
SslCreateHandshakeHash,
SslDecryptPacket,
SslEncryptPacket,
SslEnumCipherSuites,
SslExportKey,
SslFreeBuffer,
SslFreeObject,
SslGenerateMasterKey,
SslGenerateSessionKeys,
SslGetKeyProperty,
SslGetProviderProperty,
SslHashHandshake,
SslImportMasterKey,
SslImportKey,
SslLookupCipherSuiteInfo,
SslOpenPrivateKey,
SslOpenProvider,
SslSignHash,
SslVerifySignature
};


/** @function GetSChannelInterface
  * @brief Returns the function table for the specified protocol provider.
  *
  * @param pszProviderName: The name of the protocol provider
  * @param ppFunctionTable: Variable in which to write the address of the function table
  * @param dwFlags: Not Supported
  *
  * @return ERROR_SUCCESS: On success
  * @return NTE_INVALID_PARAMETER: When the protocol provider name is not equal to PROTOCOL_PROVIDER_NAME
  **/
SECURITY_STATUS
WINAPI 
GetSChannelInterface(
    __in   LPCWSTR pszProviderName,
    __out  NCRYPT_SSL_FUNCTION_TABLE **ppFunctionTable,
    __in   DWORD dwFlags)
{ 
	UNREFERENCED_PARAMETER(dwFlags);

	// Ensure that this is the correct protocol provider
	if(wcscmp(pszProviderName, PROTOCOL_PROVIDER_NAME) != 0) return NTE_INVALID_PARAMETER;

	// Pass the user the static function table associated with this protocol provider
	*ppFunctionTable = &prot_provider_table;

	return ERROR_SUCCESS;
}



