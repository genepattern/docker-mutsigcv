#!/bin/bash


# (these may be set permanently by copying the above lines into your login script)

#export LD_LIBRARY_PATH=/usr/local/MATLAB/MATLAB_Compiler_Runtime/v83/runtime/glnxa64:/usr/local/MATLAB/MATLAB_Compiler_Runtime/v83/bin/glnxa64:/usr/local/MATLAB/MATLAB_Compiler_Runtime/v83/sys/os/glnxa64:$LD_LIBRARY_PATH

export LD_LIBRARY_PATH=/usr/local/MATLAB/MATLAB_Compiler_Runtime/v81/runtime/glnxa64:/usr/local/MATLAB/MATLAB_Compiler_Runtime/v81/bin/glnxa64:/usr/local/MATLAB/MATLAB_Compiler_Runtime/v81/sys/os/glnxa64:/usr/local/MATLAB/MATLAB_Compiler_Runtime/v81/sys/java/jre/glnxa64/jre/lib/amd64/native_threads:/usr/local/MATLAB/MATLAB_Compiler_Runtime/v81/sys/java/jre/glnxa64/jre/lib/amd64/server:/usr/local/MATLAB/MATLAB_Compiler_Runtime/v81/sys/java/jre/glnxa64/jre/lib/amd64:$LD_LIBRARY_PATH

 
#Next, set the XAPPLRESDIR environment variable to the following value:

#export XAPPLRESDIR=/usr/local/MATLAB/MATLAB_Compiler_Runtime/v83/X11/app-defaults

export XAPPLRESDIR=/usr/local/MATLAB/MATLAB_Compiler_Runtime/v81/X11/app-defaults



echo --- DONE setting up environment variables ---

$@

