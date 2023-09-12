#!/bin/sh

# 
# Vivado(TM)
# runme.sh: a Vivado-generated Runs Script for UNIX
# Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
# 

if [ -z "$PATH" ]; then
  PATH=/run/media/nicolas/Coisas/Software/Xilinx/Vivado/2022.2/ids_lite/ISE/bin/lin64:/run/media/nicolas/Coisas/Software/Xilinx/Vivado/2022.2/bin
else
  PATH=/run/media/nicolas/Coisas/Software/Xilinx/Vivado/2022.2/ids_lite/ISE/bin/lin64:/run/media/nicolas/Coisas/Software/Xilinx/Vivado/2022.2/bin:$PATH
fi
export PATH

if [ -z "$LD_LIBRARY_PATH" ]; then
  LD_LIBRARY_PATH=
else
  LD_LIBRARY_PATH=:$LD_LIBRARY_PATH
fi
export LD_LIBRARY_PATH

HD_PWD='/run/media/nicolas/Coisas/Work/mestrado/design_of_digital_systems/dds-group10/assignment 3/Vivado_Tutorial/Tutorial_Created_Data/project_bft/project_bft.runs/synth_1'
cd "$HD_PWD"

HD_LOG=runme.log
/bin/touch $HD_LOG

ISEStep="./ISEWrap.sh"
EAStep()
{
     $ISEStep $HD_LOG "$@" >> $HD_LOG 2>&1
     if [ $? -ne 0 ]
     then
         exit
     fi
}

EAStep vivado -log bft.vds -m64 -product Vivado -mode batch -messageDb vivado.pb -notrace -source bft.tcl
