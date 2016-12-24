Copyright (c) Microsoft Corporation. All rights reserved.

Sample program for adding a new hash algorithm to CNG.

This sample uses CNG's Crypto Config APIs to register a new RND algorithm. After registering the new RND algorithm,
it calls the BCrypt APIs to test the new RND algorithm

It is possible for users to plug in their own algorithms in the cryptography API framework. To plug in a new RND algorithm, the users need to do the following:

1. Create a DLL for the new hash provider and register it. 
   This is shown in this sample.
2. Register the object identifiers for the new RND algorithms
   For this step, please refer to the register OID sample.
3. Use the new hash algorithm for a crypto functionality such as
   signing a certificate.
   For this step, please refer to the Plugging new RND algorithms sample.

Each of these 3 steps are in separate samples. This sample code shows step 1.

Usage Requirements:

To build this sample, compile and link it with crypt32.lib and ncrypt_provider.lib.

This sample builds a DLL.
