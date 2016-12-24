@echo off

REM In order to capture etl traces, this script relies on Xperf.exe. It is assumed 
REM that Xperf.exe will be installed in GPUView's parent directory.

REM
REM Logic:
REM
REM  If the command line is blank, we'll try to start logging using normal settings.
REM  If the command line is blank and we're already logging, we'll turn off logging.
REM  If the command line reads light, we'll turn on the minimum.
REM  If the command line reads verbose, we'll turn everything on.
REM

REM
REM Different tracing options that can be enabled
REM
REM SET XXX=(GUID|KnownProviderName)[:(Flags|Groups)[:Level[:'stack']]]
set TRACE_DXVA2=a0386e75-f70c-464c-a9ce-33c44e091623:0xffff:5
set TRACE_MMCSS=f8f10121-b617-4a56-868b-9df1b27fe32c:0xffff:5
set TRACE_WMDRM=6e03dd26-581b-4ec5-8f22-601a4de5f022:0xffff:5
set TRACE_WME=8f2048e0-f260-4f57-a8d1-932376291682
set TRACE_WMP=681069c4-b785-466a-bc63-4aa616644b68:0xffff:5
set TRACE_DVD=75d4a1bb-7cc6-44b1-906d-d5e05be6d060:0xffff:5
set TRACE_DSHOW=28cf047a-2437-4b24-b653-b9446a419a69
set TRACE_MF=f404b94e-27e0-4384-bfe8-1d8d390b0aa3+362007f7-6e50-4044-9082-dfa078c63a73:0x000000000000ffff:0x5
set TRACE_AE=a6a00efd-21f2-4a99-807e-9b3bf1d90285:0x000000000000ffff:0x3
set TRACE_HME=63770680-05F1-47E0-928A-9ACFDCF52147:0xffff:5
set TRACE_HDDVD=779d8cdc-666b-4bf4-a367-9df89d6901e8:0xffff:5
set TRACE_DWMAPIGUID=71dd85bc-d474-4974-b0f6-93ffc5bfbd04::6
set TRACE_SCHEDULEGUID=8cc44e31-7f28-4f45-9938-4810ff517464:0xffff:6
set TRACE_DX=DX
set TRACE_DXGI=CA11C036-0102-4A2D-A6AD-F03CFED5D3C9:0xf:6:'stack'
set TRACE_D3D11=db6f6ddb-ac77-4e88-8253-819df9bbf140:0xffffffffffffffff:6:'stack'
set TRACE_D3D10LEVEL9=7E7D3382-023C-43cb-95D2-6F0CA6D70381:0x1
set TRACE_DXC=802ec45a-1e99-4b83-9920-87c98277ba9d
set TRACE_DXC_ALL=%TRACE_DXC%:0xFFFF:5:'stack' 
set TRACE_DXC_LONGHAUL=%TRACE_DXC%:0x800:5
set TRACE_DXC_MIN=%TRACE_DXC%:0x800:5
set TRACE_DXC_LIGHT=%TRACE_DXC%:0x826:5
set TRACE_DXC_NORMAL=%TRACE_DXC%:0xA36:5
set TRACE_DXC_STACKS=%TRACE_DXC%:0x8041:5:'stack'
set TRACE_UMD=a688ee40-d8d9-4736-b6f9-6b74935ba3b1:0xffff:5
set TRACE_DWM=a42c77db-874f-422e-9b44-6d89fe2bd3e5:0x000000007fffffff:0x5
set TRACE_DWM2=8c9dd1ad-e6e5-4b07-b455-684a9d879900:0xFFFF:6
set TRACE_DWM3=9e9bba3c-2e38-40cb-99f4-9e8281425164:0xFFFF:6
set TRACE_CODEC=ea6d6e3b-7014-4ab1-85db-4a50cda32a82:0xffff:5
set TRACE_KMFD=E7C7EDF9-D0E4-4338-8AE3-BCA3C5B4B4A3
set TRACE_UMFD=a70bc228-e778-4061-86fa-debb03fda64a
REM set TRACE_AVALON=AvalonALL
set TRACE_TESTFRAMEWORK=31293f4f-f7bb-487d-8b3b-f537b827352f
set TRACE_TEST=42C4E0C1-0D92-46f0-842C-1E791FA78D52
set TRACE_SC=30336ed4-e327-447c-9de0-51b652c86108
set TRACE_XAML=531A35AB-63CE-4BCF-AA98-F88C7A89E455:0xffff
set TRACE_WIN32K=8c416c79-d49b-4f01-a467-e56d3aa8234c:0xffff
set TRACE_D2D=dcb453db-c652-48be-a0f8-a64459d5162e:0:5
set TRACE_D2DSCENARIOS=712909c0-6e57-4121-b639-87c8bf9004e0

REM
REM To Add another provider, create an environment varaible here
REM set TRACE_PRIVATE=X
REM

if not "%TLOG%"=="" goto Done_With_It
REM 
REM To determine physical memory
REM
if not "%TRACE_LOGGING_MEMORY%" == "" goto Do_Not_Process_File
systeminfo > me.txt
findstr /sipn /C:"Total Physical Memory" me.txt > me2.txt
REM TRACE_LOGGING_MEMORY will hold the amount of physical memory on this machine.
for /f "tokens=6 delims=: " %%a in (me2.txt) do set TRACE_LOGGING_MEMORY=%%a
del me.txt
del me2.txt
set TRACE_LOGGING_MEMORY=%TRACE_LOGGING_MEMORY:,=%
:Do_Not_Process_File

REM
REM For buffers sizes
REM
REM The cutoff for large bufers 5G, Medium buffers 2G physical memory
if %TRACE_LOGGING_MEMORY% Gtr 4000 goto Set_Large_Buffers
if %TRACE_LOGGING_MEMORY% Gtr 2000 goto Set_Medium_Buffers
REM echo !Using Small Buffers Memory Footprint here!
set TRACE_LARGE_BUFFERS=-BufferSize 1024 -MinBuffers 30 -MaxBuffers 120
set TRACE_STAND_BUFFERS=-BufferSize 1024 -MinBuffers 25 -MaxBuffers 25
goto Done_With_It
:Set_Medium_Buffers
REM echo !Using Meidum Buffers Memory Footprint here!
set TRACE_LARGE_BUFFERS=-BufferSize 1024 -MinBuffers 60 -MaxBuffers 240
set TRACE_STAND_BUFFERS=-BufferSize 1024 -MinBuffers 50 -MaxBuffers 50
goto Done_With_It
:Set_Large_Buffers
REM echo !Using Large Buffers Memory Footprint here!
set TRACE_LARGE_BUFFERS=-BufferSize 1024 -MinBuffers 120 -MaxBuffers 480
set TRACE_STAND_BUFFERS=-BufferSize 1024 -MinBuffers 100 -MaxBuffers 100
:Done_With_It

REM
REM NT logging groupings
REM 
set TRACE_NT_MIN=LOADER+PROC_THREAD+CSWITCH+DISPATCHER+POWER
set TRACE_NT_LONGHAUL=LOADER+PROC_THREAD+POWER
set TRACE_NT_LIGHT=%TRACE_NT_MIN%+DISK_IO+HARD_FAULTS
REM
REM Note in order to get callstacks on amd64 bit builds, you need to enable the following
REM registry key:
REM
REM HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management\DisablePagingExecutive
REM 
REM by setting it to 1. Lookup DisablePagingExecutive via your favorite search engine for details.
REM
set TRACE_NT_NORMAL=%TRACE_NT_LIGHT%+PROFILE+MEMINFO+DPC+INTERRUPT -stackwalk @"%~dp0\EventsForStackTrace.txt"
set TRACE_NT_VERBOSE=%TRACE_NT_LIGHT%+PROFILE+MEMINFO+SYSCALL+DPC+INTERRUPT+ALL_FAULTS -stackwalk @"%~dp0\EventsForStackTrace.txt"

REM 
REM From 'xperf -help providers' we get the following table. GPUView, at a minimum
REM really needs LOADER, PROC_THREAD and CSWITCH.
REM 
REM Kernel Flags:
REM        PROC_THREAD    : Process and Thread create/delete
REM        LOADER         : Kernel and user mode Image Load/Unload events
REM        PROFILE        : CPU Sample profile
REM        CSWITCH        : Context Switch
REM        COMPACT_CSWITCH: Compact Context Switch
REM        DISPATCHER     : CPU Scheduler
REM        DPC            : DPC Events
REM        INTERRUPT      : Interrupt events
REM        SYSCALL        : System calls
REM        PRIORITY       : Priority change events
REM        ALPC           : Advanced Local Procedure Call
REM        PERF_COUNTER   : Process Perf Counters
REM        DISK_IO        : Disk I/O
REM        DISK_IO_INIT   : Disk I/O Initiation
REM        FILE_IO        : File system operation end times and results
REM        FILE_IO_INIT   : File system operation (create/open/close/read/write)
REM        HARD_FAULTS    : Hard Page Faults
REM        FILENAME       : FileName (e.g., FileName create/delete/rundown)
REM        SPLIT_IO       : Split I/O
REM        REGISTRY       : Registry tracing
REM        DRIVERS        : Driver events
REM        POWER          : Power management events
REM        NETWORKTRACE   : Network events (e.g., tcp/udp send/receive)
REM        VIRT_ALLOC     : Virtual allocation reserve and release
REM        MEMINFO        : Memory List Info
REM        ALL_FAULTS     : All page faults including hard, Copy on write, demand zero faults, etc.


REM
REM The Environment variable TLOG (trace logging) will be used to indicate that
REM logging is active or not. if TLOG is set to ON, we're currently logging.
REM 

if "%TLOG%"=="" goto StartSection
if "%TLOG%"=="MIN" goto StopSection
if "%TLOG%"=="NORMAL" goto StopSection
if "%TLOG%"=="LIGHT" goto StopSection
if "%TLOG%"=="LONGHAUL" goto StopSection
if "%TLOG%"=="VERBOSE" goto StopSection

REM Start Logging section
:StartSection

REM 
REM If we're already logging, stop logging.
REM 
if "%TLOG%"=="MIN" goto StopSection
if "%TLOG%"=="NORMAL" goto StopSection
if "%TLOG%"=="LIGHT" goto StopSection
if "%TLOG%"=="LONGHAUL" goto StopSection
if "%TLOG%"=="VERBOSE" goto StopSection

REM
REM Check to see if they used a command line option
REM 

if "%1%" == "" goto StartNormal
if "%1%" == "normal" goto StartNormal
if "%1%" == "n" goto StartNormal
if "%1%" == "light" goto StartLight
if "%1%" == "longhaul" goto StartLonghaul
if "%1%" == "l" goto StartLight
if "%1%" == "min" goto StartMin
if "%1%" == "m" goto StartMin
if "%1%" == "verbose" goto StartVerbose
if "%1%" == "v" goto StartVerbose
goto CLUsage

:StartMin
REM
REM Start Min
REM 
if %errorlevel% GTR 0 goto OSUsage
"%~dp0"..\Xperf -on %TRACE_NT_MIN% %TRACE_LARGE_BUFFERS% -f Kernel.etl
"%~dp0"..\Xperf -start DxLogger -on %TRACE_DX%:0x9 %TRACE_LARGE_BUFFERS% -f DX.etl

"%~dp0"..\Xperf -start DxcState -on %TRACE_DXC_ALL% %TRACE_LARGE_BUFFERS% -f DXCState.etl
"%~dp0"..\Xperf -capturestate DxcState %TRACE_DXC_ALL%
"%~dp0"..\Xperf -stop DxcState
"%~dp0"..\Xperf -start DxcStackLogger -on %TRACE_DXC_STACKS% %TRACE_LARGE_BUFFERS% -f DXCStacks.etl

"%~dp0"..\Xperf -start DxcLogger -on %TRACE_DXC_MIN% %TRACE_LARGE_BUFFERS% -f DXC.etl
"%~dp0"..\Xperf -start UMDLogger -on %TRACE_UMD% %TRACE_STAND_BUFFERS% -f UMD.etl
"%~dp0"..\Xperf -capturestate UMDLogger 0xffff:5
"%~dp0"..\Xperf -start DXGILogger -on %TRACE_DXGI% %TRACE_STAND_BUFFERS% -f DXGI.etl
"%~dp0"..\Xperf -capturestate DXGILogger %TRACE_DXGI%
"%~dp0"..\Xperf -start Dx11Logger -on %TRACE_D3D11% %TRACE_STAND_BUFFERS% -f DX11.etl
"%~dp0"..\Xperf -capturestate Dx11Logger %TRACE_D3D11%
"%~dp0"..\Xperf -start D3D10Level9Logger -on %TRACE_D3D10LEVEL9% %TRACE_STAND_BUFFERS% -f D3D10Level9.etl
"%~dp0"..\Xperf -capturestate D3D10Level9Logger %TRACE_D3D10LEVEL9%
"%~dp0"..\Xperf -start XAMLLogger -on %TRACE_XAML%:4 %TRACE_STAND_BUFFERS% -f XAML.etl
set TLOG=MIN
goto EndIt

:StartLight
REM
REM Start Light
REM 
if %errorlevel% GTR 0 goto OSUsage
"%~dp0"..\Xperf -on %TRACE_NT_LIGHT% %TRACE_LARGE_BUFFERS% -f Kernel.etl
"%~dp0"..\Xperf -start DxLogger -on %TRACE_DX%:0x2F %TRACE_LARGE_BUFFERS% -f DX.etl

"%~dp0"..\Xperf -start DxcState -on %TRACE_DXC_ALL% %TRACE_LARGE_BUFFERS% -f DXCState.etl
"%~dp0"..\Xperf -capturestate DxcState %TRACE_DXC_ALL%
"%~dp0"..\Xperf -stop DxcState
"%~dp0"..\Xperf -start DxcStackLogger -on %TRACE_DXC_STACKS% %TRACE_LARGE_BUFFERS% -f DXCStacks.etl

"%~dp0"..\Xperf -start DxcLogger -on %TRACE_DXC_LIGHT% %TRACE_LARGE_BUFFERS% -f DXC.etl
"%~dp0"..\Xperf -start UMDLogger -on %TRACE_UMD% %TRACE_STAND_BUFFERS% -f UMD.etl
"%~dp0"..\Xperf -capturestate UMDLogger %TRACE_UMD%
"%~dp0"..\Xperf -start DXGILogger -on %TRACE_DXGI% %TRACE_STAND_BUFFERS% -f DXGI.etl
"%~dp0"..\Xperf -capturestate DXGILogger %TRACE_DXGI%
"%~dp0"..\Xperf -start Dx11Logger -on %TRACE_D3D11% %TRACE_STAND_BUFFERS% -f DX11.etl
"%~dp0"..\Xperf -capturestate Dx11Logger %TRACE_D3D11%
"%~dp0"..\Xperf -start D3D10Level9Logger -on %TRACE_D3D10LEVEL9% %TRACE_STAND_BUFFERS% -f D3D10Level9.etl
"%~dp0"..\Xperf -capturestate D3D10Level9Logger %TRACE_D3D10LEVEL9%
"%~dp0"..\Xperf -start MfLogger -on %TRACE_MF%+%TRACE_WME% %TRACE_STAND_BUFFERS% -f mf.etl
"%~dp0"..\Xperf -start XAMLLogger -on %TRACE_XAML%:4 %TRACE_STAND_BUFFERS% -f XAML.etl
set TLOG=LIGHT
goto EndIt

:StartLonghaul
REM
REM Start Longhaul
REM 
if %errorlevel% GTR 0 goto OSUsage
"%~dp0"..\Xperf -on %TRACE_NT_LONGHAUL% %TRACE_LARGE_BUFFERS% -f Kernel.etl
"%~dp0"..\Xperf -start DxcLogger -on %TRACE_DXC_LONGHAUL% %TRACE_LARGE_BUFFERS% -f DXC.etl
"%~dp0"..\Xperf -capturestate DxcLogger %TRACE_DXC_LONGHAUL%
set TLOG=LONGHAUL
goto EndIt

:StartNormal
REM
REM Start Normal
REM
REM To enable private provider
REM Xperf -start PriLogger -on %TRACE_PRIVATE% %TRACE_LARGE_BUFFERS% -f Private.etl
REM
if %errorlevel% GTR 0 goto OSUsage
"%~dp0"..\Xperf -on %TRACE_NT_NORMAL% %TRACE_LARGE_BUFFERS% -f Kernel.etl
"%~dp0"..\Xperf -start DxTest -on %TRACE_TESTFRAMEWORK%+%TRACE_TEST% %TRACE_STAND_BUFFERS% -f DxTest.etl
"%~dp0"..\Xperf -start DxLogger -on %TRACE_DX%:0x2F %TRACE_LARGE_BUFFERS% -f DX.etl

"%~dp0"..\Xperf -start DxcState -on %TRACE_DXC_ALL% %TRACE_LARGE_BUFFERS% -f DXCState.etl
"%~dp0"..\Xperf -capturestate DxcState %TRACE_DXC_ALL%
"%~dp0"..\Xperf -stop DxcState
"%~dp0"..\Xperf -start DxcStackLogger -on %TRACE_DXC_STACKS% %TRACE_LARGE_BUFFERS% -f DXCStacks.etl

"%~dp0"..\Xperf -start DxcLogger -on %TRACE_DXC_NORMAL% %TRACE_LARGE_BUFFERS% -f DXC.etl
"%~dp0"..\Xperf -start UMDLogger -on %TRACE_UMD% %TRACE_STAND_BUFFERS% -f UMD.etl
"%~dp0"..\Xperf -capturestate UMDLogger %TRACE_UMD%
"%~dp0"..\Xperf -start DXGILogger -on %TRACE_DXGI% %TRACE_STAND_BUFFERS% -f DXGI.etl
"%~dp0"..\Xperf -capturestate DXGILogger %TRACE_DXGI%
"%~dp0"..\Xperf -start Dx11Logger -on %TRACE_D3D11% %TRACE_STAND_BUFFERS% -f DX11.etl
"%~dp0"..\Xperf -capturestate Dx11Logger %TRACE_D3D11%
"%~dp0"..\Xperf -start D3D10Level9Logger -on %TRACE_D3D10LEVEL9% %TRACE_STAND_BUFFERS% -f D3D10Level9.etl
"%~dp0"..\Xperf -capturestate D3D10Level9Logger %TRACE_D3D10LEVEL9%
"%~dp0"..\Xperf -start MFLogger -on %TRACE_DSHOW%+%TRACE_MF%+%TRACE_AE%+%TRACE_DXVA2%+%TRACE_WME% %TRACE_STAND_BUFFERS% -f MF.etl
"%~dp0"..\Xperf -start OLogger -on %TRACE_SCHEDULEGUID%+%TRACE_SC%+%TRACE_WIN32K%+%TRACE_DWM%+%TRACE_DWM2%+%TRACE_DWM3% %TRACE_STAND_BUFFERS% -f Other.etl
"%~dp0"..\Xperf -start XAMLLogger -on %TRACE_XAML%:4 %TRACE_STAND_BUFFERS% -f XAML.etl
"%~dp0"..\Xperf -start D2DLogger -on %TRACE_D2D% %TRACE_STAND_BUFFERS% -f D2D.etl
"%~dp0"..\Xperf -start D2DScenariosLogger -on %TRACE_D2DSCENARIOS% %TRACE_STAND_BUFFERS% -f D2DScenarios.etl
set TLOG=NORMAL
goto EndIt

:StartVerbose
REM
REM Start Verbose
REM 
if %errorlevel% GTR 0 goto OSUsage
"%~dp0"..\Xperf -setprofint 1221
"%~dp0"..\Xperf -on %TRACE_NT_NORMAL% %TRACE_LARGE_BUFFERS% -f Kernel.etl
"%~dp0"..\Xperf -start DxTest -on %TRACE_TESTFRAMEWORK%+%TRACE_TEST% %TRACE_STAND_BUFFERS% -f DxTest.etl
"%~dp0"..\Xperf -start DxLogger -on %TRACE_DX% %TRACE_LARGE_BUFFERS% -f DX.etl

"%~dp0"..\Xperf -start DxcState -on %TRACE_DXC_ALL% %TRACE_LARGE_BUFFERS% -f DXCState.etl
"%~dp0"..\Xperf -capturestate DxcState %TRACE_DXC_ALL%
"%~dp0"..\Xperf -stop DxcState
"%~dp0"..\Xperf -start DxcStackLogger -on %TRACE_DXC_STACKS% %TRACE_LARGE_BUFFERS% -f DXCStacks.etl

"%~dp0"..\Xperf -start DxcLogger -on %TRACE_DXC_NORMAL% %TRACE_LARGE_BUFFERS% -f DXC.etl
"%~dp0"..\Xperf -start UMDLogger -on %TRACE_UMD% %TRACE_STAND_BUFFERS% -f UMD.etl
"%~dp0"..\Xperf -capturestate UMDLogger %TRACE_UMD%
"%~dp0"..\Xperf -start DXGILogger -on %TRACE_DXGI% %TRACE_STAND_BUFFERS% -f DXGI.etl
"%~dp0"..\Xperf -capturestate DXGILogger %TRACE_DXGI%
"%~dp0"..\Xperf -start Dx11Logger -on %TRACE_D3D11% %TRACE_STAND_BUFFERS% -f DX11.etl
"%~dp0"..\Xperf -capturestate Dx11Logger %TRACE_D3D11%
"%~dp0"..\Xperf -start D3D10Level9Logger -on %TRACE_D3D10LEVEL9% %TRACE_STAND_BUFFERS% -f D3D10Level9.etl
"%~dp0"..\Xperf -capturestate D3D10Level9Logger %TRACE_D3D10LEVEL9%
"%~dp0"..\Xperf -start MFLogger -on %TRACE_DSHOW%+%TRACE_MF%+%TRACE_AE%+%TRACE_MMCSS%+%TRACE_WMDRM%+%TRACE_DXVA2%+%TRACE_WMP%+%TRACE_DVD%+%TRACE_WME% %TRACE_STAND_BUFFERS% -f MF.etl
"%~dp0"..\Xperf -start OLogger -on %TRACE_HME%+%TRACE_HDDVD%+%TRACE_DWMAPIGUID%+%TRACE_SCHEDULEGUID%+%TRACE_SC%+%TRACE_WIN32K%+%TRACE_DWM%+%TRACE_DWM2%+%TRACE_DWM3%+%TRACE_CODEC% %TRACE_STAND_BUFFERS% -f Other.etl
"%~dp0"..\Xperf -start XAMLLogger -on %TRACE_XAML%:5 %TRACE_STAND_BUFFERS% -f XAML.etl
"%~dp0"..\Xperf -start D2DLogger -on %TRACE_D2D% %TRACE_STAND_BUFFERS% -f D2D.etl
"%~dp0"..\Xperf -start D2DScenariosLogger -on %TRACE_D2DSCENARIOS% %TRACE_STAND_BUFFERS% -f D2DScenarios.etl
set TLOG=VERBOSE
goto EndIt





REM Stop Logging section
:StopSection
REM
REM Here is where we determine how to shut things off
REM

if "%TLOG%"=="MIN" goto StopMin
if "%TLOG%"=="LIGHT" goto StopLight
if "%TLOG%"=="LONGHAUL" goto StopLonghaul
if "%TLOG%"=="NORMAL" goto StopNormal
if "%TLOG%"=="VERBOSE" goto StopVerbose
goto EndIt

:StopMin
"%~dp0"..\Xperf -stop XAMLLogger
"%~dp0"..\Xperf -stop DxLogger
"%~dp0"..\Xperf -stop DxcStackLogger
"%~dp0"..\Xperf -stop DxcLogger
"%~dp0"..\Xperf -stop UMDLogger
"%~dp0"..\Xperf -stop DXGILogger
"%~dp0"..\Xperf -stop Dx11Logger
"%~dp0"..\Xperf -stop D3D10Level9Logger
"%~dp0"..\Xperf.exe -stop
echo All loggers stopped, starting merge...
"%~dp0"..\Xperf -merge XAML.etl DX.etl DXC.etl DXCStacks.etl UMD.etl DXGI.etl DX11.etl D3D10level9.etl kernel.etl DxcState.etl Merged.etl
echo Restoring Performance Counter Interval
"%~dp0"..\Xperf -setprofint
set TLOG=
goto EndIt

:StopLight
"%~dp0"..\Xperf -stop XAMLLogger
"%~dp0"..\Xperf -stop MFLogger
"%~dp0"..\Xperf -stop DxLogger
"%~dp0"..\Xperf -stop DxcStackLogger
"%~dp0"..\Xperf -stop DxcLogger
"%~dp0"..\Xperf -stop UMDLogger
"%~dp0"..\Xperf -stop DXGILogger
"%~dp0"..\Xperf -stop Dx11Logger
"%~dp0"..\Xperf -stop D3D10Level9Logger
"%~dp0"..\Xperf.exe -stop
echo All loggers stopped, starting merge...
"%~dp0"..\Xperf -merge XAML.etl MF.etl DX.etl DXC.etl DXCStacks.etl UMD.etl DXGI.etl DX11.etl D3D10level9.etl kernel.etl DxcState.etl Merged.etl
echo Restoring Performance Counter Interval
"%~dp0"..\Xperf -setprofint
set TLOG=
goto EndIt

:StopLonghaul
"%~dp0"..\Xperf -stop DxcLogger
"%~dp0"..\Xperf.exe -stop
echo All loggers stopped, starting merge...
"%~dp0"..\Xperf -merge DXC.etl kernel.etl Merged.etl
echo Restoring Performance Counter Interval
"%~dp0"..\Xperf -setprofint
set TLOG=
goto EndIt

:StopNormal
REM
REM To stop private provider
REM Xperf -stop PriLogger
REM
"%~dp0"..\Xperf -stop XAMLLogger
"%~dp0"..\Xperf -stop DxTest
"%~dp0"..\Xperf -stop OLogger
"%~dp0"..\Xperf -stop MFLogger
"%~dp0"..\Xperf -stop DxLogger
"%~dp0"..\Xperf -stop DxcStackLogger
"%~dp0"..\Xperf -stop DxcLogger
"%~dp0"..\Xperf -stop UMDLogger
"%~dp0"..\Xperf -stop DXGILogger
"%~dp0"..\Xperf -stop Dx11Logger
"%~dp0"..\Xperf -stop D3D10Level9Logger
"%~dp0"..\Xperf -stop D2DLogger
"%~dp0"..\Xperf -stop D2DScenariosLogger
"%~dp0"..\Xperf.exe -stop
echo All loggers stopped, starting merge...
"%~dp0"..\Xperf -merge XAML.etl Other.etl MF.etl DX.etl DXC.etl DXCStacks.etl UMD.etl DXGI.etl DX11.etl D3D10level9.etl kernel.etl DxTest.etl D2D.etl D2DScenarios.etl DxcState.etl Merged.etl
echo Restoring Performance Counter Interval
"%~dp0"..\Xperf -setprofint
set TLOG=
goto EndIt

:StopVerbose
"%~dp0"..\Xperf -stop XAMLLogger
"%~dp0"..\Xperf -stop DxTest
"%~dp0"..\Xperf -stop OLogger
"%~dp0"..\Xperf -stop MFLogger
"%~dp0"..\Xperf -stop DxLogger
"%~dp0"..\Xperf -stop DxcStackLogger
"%~dp0"..\Xperf -stop DxcLogger
"%~dp0"..\Xperf -stop UMDLogger
"%~dp0"..\Xperf -stop DXGILogger
"%~dp0"..\Xperf -stop Dx11Logger
"%~dp0"..\Xperf -stop D3D10Level9Logger
"%~dp0"..\Xperf -stop D2DLogger
"%~dp0"..\Xperf -stop D2DScenariosLogger
"%~dp0"..\Xperf.exe -stop
echo All loggers stopped, starting merge...
"%~dp0"..\Xperf -merge XAML.etl Other.etl MF.etl DX.etl DXC.etl DXCStacks.etl UMD.etl DXGI.etl DX11.etl D3D10level9.etl kernel.etl DxTest.etl D2D.etl D2DScenarios.etl DxcState.etl Merged.etl
echo Restoring Performance Counter Interval
"%~dp0"..\Xperf -setprofint
set TLOG=
goto EndIt


REM
REM Error message section.
REM

:OSUsage
echo Error: Logging should be done on Vista capable OS.
goto EndIt

:CLUsage
echo Error: Invalid command line argument.
goto EndIt

:EndIt
@echo on

