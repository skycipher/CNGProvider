Copyright (c) Microsoft Corporation. All rights reserved.

Using a new hash algorithm to create self-signed certificate.

This sample code shows how to use a new hash algorithm to create a self-signed certificate. 

It is possible for users to plug in their own algorithms in the cryptography API framework. To plug in a new hash algorithm, the users need to do the following:

1. Create a DLL for the new hash provider and register it.
   For this step, please refer to the hash provider sample
   Copy the hash provider DLL to %windir%\System32\
2. Register the object identifiers for the new hash algorithms
   For this step, please refer to the register OID sample.
   As an alternative, add the information in the registerOID.reg file included in this sample to the registry
   This file is the resultant registry entries created by the register OID sample.
3. Use the new hash algorithm for a crypto functionality such as signing a certificate.

The first two steps are shown in separate Platform SDK samples. This sample shows the third step, i.e, how to create a certificate signed using the new hash algorithm.

The sample code also illustrates the use of ECC public key algorithm.
The CertCreateSelfSignCertificate API which is used to create the certificate requires the key provider information for the ECC key. The sample shows how to create this ECC key using the new Cryptography API.

There are two ways of providing the Hash and Public key algorithms for signing the certificate. One way is to encode the hash algorithm in the parameters of the signature algorithm. This is achieved using the CryptEncodeObject API as illustrated in this sample code. The other way to provide a combined OID of the hash and public key algorithm as the signature algorithm

APIs:

This example illustrates the use of the following APIs,

1. CertStrToName: This converts a string to an encoded certificate name
2. CryptFindOIDInfo: This function can be used to locate the OID 
    corresponding to a particular hash algorithm
3. CryptEncodeObject: This function encodes a structure of the type indicated
    by the value of the lpszStructType parameter. We use it to encode the hash
	algorithm as part of the parameters passed to the signing algorithm.
4. CertCreateSelfSignCertificate: This function creates a self signed 
    certificate signed using the new algorithm

Usage Requirements:

This sample is the 3rd step of the scenario of installing and using new hash algorithms. Before running this sample, register the hash provider dll and register the OIDs for the new hash algorithms. 

To run this sample, compile and link it with crypt32.lib and ncrypt.lib.


