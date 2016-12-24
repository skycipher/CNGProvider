GENERATING A TRACE
==================

Open a command prompt with administrative privilege:

Find Start->All Programs->Accessories->Command Prompt
Right click on the command prompt icon and select Run as Administrator.

Once at the command prompt, navigate to the GPUView directory and type the 
following commands:

Log.cmd

Repro the problem (no more than 30seconds to 1 minute). Then retype the same 
command:

Log.cmd

Use GPUView to view the resulting Merged.ETL file.


USING GPUVIEW
=============

GPUView commands
Ctrl+e  bring up the event viewer
a       Zoom in
z       Zoom out
s       Zoom in 10x
x       Zoom out 10x
Mouse	Select a region by click and dragging with the left button.
        Right-click deselects the region.
Ctrl+z  Sets the current view as the time frame selected by the current region.

Hints:

Preemption buffers are shown in the hardware queue as black blocks
Paging buffers are shown in the hardware queue as red blocks
Packets with red cross-hatches contain present calls

In the event viewer, the Event List displays all events that match 
the selected GUID's and are within "Start Time" and "End Time."
Cur View Time will set Start Time to the left side of the screen and
End Time to the right side.  Selection Time will set Start Time and
End Time as the current selection.

Events highlighted in the Event List appear as vertical red bars in the time
view.  VSync markings automatically put vertical blue bars on all VSync
events.

The color scheme is the following:
---------------------------------

HardwareQueue:
    Red = Paging Buffer
    Black = Preemption request

ContextQueue
    Light Pink = Queued WaitForSynchronizationObject
    Dark Pink = Queued SignalSynchronizationObject
    Orange = Queued MmIoFlip

For Wait/Signal operation GPUView assigns a letter to each synchronization 
object (ex: A,B,C...) and instance count for each wait/signal pair. The A42 
signal will unwait the A42 wait. There is currently a known bug when logging is 
started after the synchronization object is created in which case you'll always 
see an instance of 0.

For MmIoFlip, GPUView displays the VidPnSource & the allocation handle for the 
allocation being flipped to. 

Packet that have red cross hash contain present operation (either to the 
primary or redirect through the DWM).

Packet that have a red grid (no hash) represent messages sent to the worker 
thread (internal dxgkrnl stuff).

Detailed documentation:

See the installed GPUView.chm for the latest documentation.

