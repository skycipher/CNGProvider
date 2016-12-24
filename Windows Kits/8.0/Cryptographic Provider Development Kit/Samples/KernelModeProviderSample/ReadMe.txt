Kernel Mode Provider Sample

The sample shows how to create a sample kernel mode provider

Usage:
copy kmprov.sys %windir%\system32\drivers\
sc create kmprov binpath=%windir%\system32\drivers\kmprov.sys type=kernel
sc start kmprov
