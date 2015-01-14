@echo off
rem  Vivado(TM)
rem  compile.bat: a Vivado-generated XSim simulation Script
rem  Copyright 1986-2014 Xilinx, Inc. All Rights Reserved.

set PATH=%XILINX%\lib\%PLATFORM%;%XILINX%\bin\%PLATFORM%;C:/Xilinx/Vivado/2014.2/ids_lite/ISE/bin/nt;C:/Xilinx/Vivado/2014.2/ids_lite/ISE/lib/nt;C:/Xilinx/Vivado/2014.2/bin;%PATH%
set XILINX_PLANAHEAD=C:/Xilinx/Vivado/2014.2

xelab -m32 --debug typical --relax -L xil_defaultlib -L secureip --snapshot trial1_tb_behav --prj "C:/Documents and Settings/CONCOURS/accelero/accelero.sim/sim_1/behav/trial1_tb.prj"   xil_defaultlib.trial1_tb
if errorlevel 1 (
   cmd /c exit /b %errorlevel%
)
