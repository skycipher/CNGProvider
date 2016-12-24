Copyright (c) Microsoft Corporation. All rights reserved.

Installing the OIDs for new hash algorithms

This sample code shows how to install OIDs for new hash algorithms 

This example illustrates the use of CryptRegisterOIDInfo API to create registry entries for the new OIDs

It is possible for users to plug in their own algorithms in the cryptography API framework. To plug in a new hash algorithm, the users need to do the following:

1. Create a DLL for the new hash provider and register it. 
   For this step, please refer to the hash provider sample.
2. Register the object identifiers for the new hash algorithms
   This is shown in this sample.
3. Use the new hash algorithm for a crypto functionality such as
   signing a certificate.
   For this step, please refer to the Plugging new hash algorithms sample.

Each of these 3 steps are in separate samples. This sample code shows the step 2, i.e. registering the OIDs for the new hash algorithms.

Usage Requirements:

The entry points to DllRegisterServer and DllUnregisterServer are exported in the registerOID.def file.

To build this sample, compile and link it with crypt32.lib and ncrypt.lib.

This sample builds a DLL.
Run regsvr32.exe to register the OIDs in this dll.





