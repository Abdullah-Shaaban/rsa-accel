
�
Command: %s
1870*	planAhead2�
�read_checkpoint -auto_incremental -incremental {/run/media/nicolas/Coisas/Work/mestrado/design_of_digital_systems/dds-group10/assignment 4/project_1/project_1.srcs/utils_1/imports/synth_1/latch.dcp}2default:defaultZ12-2866h px� 
�
;Read reference checkpoint from %s for incremental synthesis3154*	planAhead2�
�/run/media/nicolas/Coisas/Work/mestrado/design_of_digital_systems/dds-group10/assignment 4/project_1/project_1.srcs/utils_1/imports/synth_1/latch.dcp2default:defaultZ12-5825h px� 
T
-Please ensure there are no constraint changes3725*	planAheadZ12-7989h px� 
r
Command: %s
53*	vivadotcl2A
-synth_design -top task2 -part xc7z020clg400-12default:defaultZ4-113h px� 
:
Starting synth_design
149*	vivadotclZ4-321h px� 
�
@Attempting to get a license for feature '%s' and/or device '%s'
308*common2
	Synthesis2default:default2
xc7z0202default:defaultZ17-347h px� 
�
0Got license for feature '%s' and/or device '%s'
310*common2
	Synthesis2default:default2
xc7z0202default:defaultZ17-349h px� 

VNo compile time benefit to using incremental synthesis; A full resynthesis will be run2353*designutilsZ20-5440h px� 
�
�Flow is switching to default flow due to incremental criteria not met. If you would like to alter this behaviour and have the flow terminate instead, please set the following parameter config_implementation {autoIncr.Synth.RejectBehavior Terminate}2229*designutilsZ20-4379h px� 
�
HMultithreading enabled for synth_design using a maximum of %s processes.4828*oasys2
42default:defaultZ8-7079h px� 
a
?Launching helper process for spawning children vivado processes4827*oasysZ8-7078h px� 
`
#Helper process launched with PID %s4824*oasys2
309702default:defaultZ8-7075h px� 
�
5undeclared symbol '%s', assumed default net type '%s'7502*oasys2
REGCCE2default:default2
wire2default:default2{
e/run/media/nicolas/Coisas/Software/Xilinx/Vivado/2022.2/data/verilog/src/unimacro/BRAM_SINGLE_MACRO.v2default:default2
21702default:default8@Z8-11241h px� 
�
%s*synth2�
�Starting Synthesize : Time (s): cpu = 00:00:02 ; elapsed = 00:00:03 . Memory (MB): peak = 1644.227 ; gain = 323.832 ; free physical = 46252 ; free virtual = 69682
2default:defaulth px� 
�
%s*synth2}
iSynthesis current peak Physical Memory [PSS] (MB): peak = 1073.648; parent = 864.067; children = 209.581
2default:defaulth px� 
�
%s*synth2}
iSynthesis current peak Virtual Memory [VSS] (MB): peak = 2612.184; parent = 1644.230; children = 967.953
2default:defaulth px� 
�
synthesizing module '%s'638*oasys2
task22default:default2�
�/run/media/nicolas/Coisas/Work/mestrado/design_of_digital_systems/dds-group10/assignment 4/project_1/project_1.srcs/sources_1/new/task2.vhd2default:default2
122default:default8@Z8-638h px� 
�
Esignal '%s' is read in the process but is not in the sensitivity list614*oasys2
a2default:default2�
�/run/media/nicolas/Coisas/Work/mestrado/design_of_digital_systems/dds-group10/assignment 4/project_1/project_1.srcs/sources_1/new/task2.vhd2default:default2
142default:default8@Z8-614h px� 
�
Esignal '%s' is read in the process but is not in the sensitivity list614*oasys2
b2default:default2�
�/run/media/nicolas/Coisas/Work/mestrado/design_of_digital_systems/dds-group10/assignment 4/project_1/project_1.srcs/sources_1/new/task2.vhd2default:default2
142default:default8@Z8-614h px� 
�
%done synthesizing module '%s' (%s#%s)256*oasys2
task22default:default2
02default:default2
12default:default2�
�/run/media/nicolas/Coisas/Work/mestrado/design_of_digital_systems/dds-group10/assignment 4/project_1/project_1.srcs/sources_1/new/task2.vhd2default:default2
122default:default8@Z8-256h px� 
�
%s*synth2�
�Finished Synthesize : Time (s): cpu = 00:00:03 ; elapsed = 00:00:04 . Memory (MB): peak = 1713.195 ; gain = 392.801 ; free physical = 46330 ; free virtual = 69761
2default:defaulth px� 
�
%s*synth2}
iSynthesis current peak Physical Memory [PSS] (MB): peak = 1073.648; parent = 864.067; children = 209.581
2default:defaulth px� 
�
%s*synth2}
iSynthesis current peak Virtual Memory [VSS] (MB): peak = 2681.152; parent = 1713.199; children = 967.953
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Constraint Validation : Time (s): cpu = 00:00:04 ; elapsed = 00:00:04 . Memory (MB): peak = 1728.039 ; gain = 407.645 ; free physical = 46316 ; free virtual = 69746
2default:defaulth px� 
�
%s*synth2}
iSynthesis current peak Physical Memory [PSS] (MB): peak = 1073.648; parent = 864.067; children = 209.581
2default:defaulth px� 
�
%s*synth2}
iSynthesis current peak Virtual Memory [VSS] (MB): peak = 2695.996; parent = 1728.043; children = 967.953
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
V
%s
*synth2>
*Start Loading Part and Timing Information
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
J
%s
*synth22
Loading part: xc7z020clg400-1
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Loading Part and Timing Information : Time (s): cpu = 00:00:04 ; elapsed = 00:00:04 . Memory (MB): peak = 1736.043 ; gain = 415.648 ; free physical = 46316 ; free virtual = 69746
2default:defaulth px� 
V
Loading part %s157*device2#
xc7z020clg400-12default:defaultZ21-403h px� 
�
%s*synth2}
iSynthesis current peak Physical Memory [PSS] (MB): peak = 1073.648; parent = 864.067; children = 209.581
2default:defaulth px� 
�
%s*synth2}
iSynthesis current peak Virtual Memory [VSS] (MB): peak = 2704.000; parent = 1736.047; children = 967.953
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished RTL Optimization Phase 2 : Time (s): cpu = 00:00:04 ; elapsed = 00:00:04 . Memory (MB): peak = 1736.043 ; gain = 415.648 ; free physical = 46311 ; free virtual = 69742
2default:defaulth px� 
�
%s*synth2}
iSynthesis current peak Physical Memory [PSS] (MB): peak = 1073.648; parent = 864.067; children = 209.581
2default:defaulth px� 
�
%s*synth2}
iSynthesis current peak Virtual Memory [VSS] (MB): peak = 2704.000; parent = 1736.047; children = 967.953
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
L
%s
*synth24
 Start RTL Component Statistics 
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
K
%s
*synth23
Detailed RTL Component Info : 
2default:defaulth p
x
� 
8
%s
*synth2 
+---XORs : 
2default:defaulth p
x
� 
Z
%s
*synth2B
.	   2 Input      1 Bit         XORs := 1     
2default:defaulth p
x
� 
=
%s
*synth2%
+---Registers : 
2default:defaulth p
x
� 
Z
%s
*synth2B
.	                1 Bit    Registers := 2     
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
O
%s
*synth27
#Finished RTL Component Statistics 
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
H
%s
*synth20
Start Part Resource Summary
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s
*synth2k
WPart Resources:
DSPs: 220 (col length:60)
BRAMs: 280 (col length: RAMB18 60 RAMB36 30)
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
K
%s
*synth23
Finished Part Resource Summary
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
W
%s
*synth2?
+Start Cross Boundary and Area Optimization
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
H
&Parallel synthesis criteria is not met4829*oasysZ8-7080h px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Cross Boundary and Area Optimization : Time (s): cpu = 00:00:07 ; elapsed = 00:00:07 . Memory (MB): peak = 1881.137 ; gain = 560.742 ; free physical = 46011 ; free virtual = 69443
2default:defaulth px� 
�
%s*synth2~
jSynthesis current peak Physical Memory [PSS] (MB): peak = 1303.803; parent = 1094.253; children = 209.581
2default:defaulth px� 
�
%s*synth2}
iSynthesis current peak Virtual Memory [VSS] (MB): peak = 2849.094; parent = 1881.141; children = 967.953
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
F
%s
*synth2.
Start Timing Optimization
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Timing Optimization : Time (s): cpu = 00:00:07 ; elapsed = 00:00:07 . Memory (MB): peak = 1881.137 ; gain = 560.742 ; free physical = 46007 ; free virtual = 69440
2default:defaulth px� 
�
%s*synth2~
jSynthesis current peak Physical Memory [PSS] (MB): peak = 1308.850; parent = 1099.300; children = 209.581
2default:defaulth px� 
�
%s*synth2}
iSynthesis current peak Virtual Memory [VSS] (MB): peak = 2849.094; parent = 1881.141; children = 967.953
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
E
%s
*synth2-
Start Technology Mapping
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Technology Mapping : Time (s): cpu = 00:00:07 ; elapsed = 00:00:07 . Memory (MB): peak = 1889.145 ; gain = 568.750 ; free physical = 46004 ; free virtual = 69436
2default:defaulth px� 
�
%s*synth2~
jSynthesis current peak Physical Memory [PSS] (MB): peak = 1308.850; parent = 1099.300; children = 209.581
2default:defaulth px� 
�
%s*synth2}
iSynthesis current peak Virtual Memory [VSS] (MB): peak = 2857.102; parent = 1889.148; children = 967.953
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
?
%s
*synth2'
Start IO Insertion
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
Q
%s
*synth29
%Start Flattening Before IO Insertion
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
T
%s
*synth2<
(Finished Flattening Before IO Insertion
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
H
%s
*synth20
Start Final Netlist Cleanup
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
K
%s
*synth23
Finished Final Netlist Cleanup
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished IO Insertion : Time (s): cpu = 00:00:09 ; elapsed = 00:00:10 . Memory (MB): peak = 1889.145 ; gain = 568.750 ; free physical = 46007 ; free virtual = 69439
2default:defaulth px� 
�
%s*synth2~
jSynthesis current peak Physical Memory [PSS] (MB): peak = 1308.850; parent = 1099.300; children = 209.581
2default:defaulth px� 
�
%s*synth2}
iSynthesis current peak Virtual Memory [VSS] (MB): peak = 2857.102; parent = 1889.148; children = 967.953
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
O
%s
*synth27
#Start Renaming Generated Instances
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Renaming Generated Instances : Time (s): cpu = 00:00:09 ; elapsed = 00:00:10 . Memory (MB): peak = 1889.145 ; gain = 568.750 ; free physical = 46007 ; free virtual = 69439
2default:defaulth px� 
�
%s*synth2~
jSynthesis current peak Physical Memory [PSS] (MB): peak = 1308.850; parent = 1099.300; children = 209.581
2default:defaulth px� 
�
%s*synth2}
iSynthesis current peak Virtual Memory [VSS] (MB): peak = 2857.102; parent = 1889.148; children = 967.953
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
2multi-driven net on pin %s with %s driver pin '%s'4708*oasys2
y_OBUF2default:default2
1st2default:default2%
y_OBUF_inst_i_1/O2default:default2�
�/run/media/nicolas/Coisas/Work/mestrado/design_of_digital_systems/dds-group10/assignment 4/project_1/project_1.srcs/sources_1/new/task2.vhd2default:default2
162default:default8@Z8-6859h px� 
�
2multi-driven net on pin %s with %s driver pin '%s'4708*oasys2
y_OBUF2default:default2
2nd2default:default2
y_reg/Q2default:default2�
�/run/media/nicolas/Coisas/Work/mestrado/design_of_digital_systems/dds-group10/assignment 4/project_1/project_1.srcs/sources_1/new/task2.vhd2default:default2
242default:default8@Z8-6859h px� 
D
%s
*synth2,

Report Check Netlist: 
2default:defaulth p
x
� 
u
%s
*synth2]
I+------+------------------+-------+---------+-------+------------------+
2default:defaulth p
x
� 
u
%s
*synth2]
I|      |Item              |Errors |Warnings |Status |Description       |
2default:defaulth p
x
� 
u
%s
*synth2]
I+------+------------------+-------+---------+-------+------------------+
2default:defaulth p
x
� 
u
%s
*synth2]
I|1     |multi_driven_nets |      0|        1|Failed |Multi driven nets |
2default:defaulth p
x
� 
u
%s
*synth2]
I+------+------------------+-------+---------+-------+------------------+
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
L
%s
*synth24
 Start Rebuilding User Hierarchy
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Rebuilding User Hierarchy : Time (s): cpu = 00:00:09 ; elapsed = 00:00:10 . Memory (MB): peak = 1889.145 ; gain = 568.750 ; free physical = 46007 ; free virtual = 69439
2default:defaulth px� 
�
%s*synth2~
jSynthesis current peak Physical Memory [PSS] (MB): peak = 1308.850; parent = 1099.300; children = 209.581
2default:defaulth px� 
�
%s*synth2}
iSynthesis current peak Virtual Memory [VSS] (MB): peak = 2857.102; parent = 1889.148; children = 967.953
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
K
%s
*synth23
Start Renaming Generated Ports
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Renaming Generated Ports : Time (s): cpu = 00:00:09 ; elapsed = 00:00:10 . Memory (MB): peak = 1889.145 ; gain = 568.750 ; free physical = 46007 ; free virtual = 69439
2default:defaulth px� 
�
%s*synth2~
jSynthesis current peak Physical Memory [PSS] (MB): peak = 1308.850; parent = 1099.300; children = 209.581
2default:defaulth px� 
�
%s*synth2}
iSynthesis current peak Virtual Memory [VSS] (MB): peak = 2857.102; parent = 1889.148; children = 967.953
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
M
%s
*synth25
!Start Handling Custom Attributes
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Handling Custom Attributes : Time (s): cpu = 00:00:09 ; elapsed = 00:00:10 . Memory (MB): peak = 1889.145 ; gain = 568.750 ; free physical = 46007 ; free virtual = 69439
2default:defaulth px� 
�
%s*synth2~
jSynthesis current peak Physical Memory [PSS] (MB): peak = 1308.850; parent = 1099.300; children = 209.581
2default:defaulth px� 
�
%s*synth2}
iSynthesis current peak Virtual Memory [VSS] (MB): peak = 2857.102; parent = 1889.148; children = 967.953
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
J
%s
*synth22
Start Renaming Generated Nets
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Renaming Generated Nets : Time (s): cpu = 00:00:09 ; elapsed = 00:00:10 . Memory (MB): peak = 1889.145 ; gain = 568.750 ; free physical = 46007 ; free virtual = 69439
2default:defaulth px� 
�
%s*synth2~
jSynthesis current peak Physical Memory [PSS] (MB): peak = 1308.850; parent = 1099.300; children = 209.581
2default:defaulth px� 
�
%s*synth2}
iSynthesis current peak Virtual Memory [VSS] (MB): peak = 2857.102; parent = 1889.148; children = 967.953
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
K
%s
*synth23
Start Writing Synthesis Report
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
A
%s
*synth2)

Report BlackBoxes: 
2default:defaulth p
x
� 
J
%s
*synth22
+-+--------------+----------+
2default:defaulth p
x
� 
J
%s
*synth22
| |BlackBox name |Instances |
2default:defaulth p
x
� 
J
%s
*synth22
+-+--------------+----------+
2default:defaulth p
x
� 
J
%s
*synth22
+-+--------------+----------+
2default:defaulth p
x
� 
A
%s*synth2)

Report Cell Usage: 
2default:defaulth px� 
B
%s*synth2*
+------+-----+------+
2default:defaulth px� 
B
%s*synth2*
|      |Cell |Count |
2default:defaulth px� 
B
%s*synth2*
+------+-----+------+
2default:defaulth px� 
B
%s*synth2*
|1     |BUFG |     1|
2default:defaulth px� 
B
%s*synth2*
|2     |LUT2 |     1|
2default:defaulth px� 
B
%s*synth2*
|3     |FDCE |     2|
2default:defaulth px� 
B
%s*synth2*
|4     |IBUF |     4|
2default:defaulth px� 
B
%s*synth2*
|5     |OBUF |     1|
2default:defaulth px� 
B
%s*synth2*
+------+-----+------+
2default:defaulth px� 
E
%s
*synth2-

Report Instance Areas: 
2default:defaulth p
x
� 
N
%s
*synth26
"+------+---------+-------+------+
2default:defaulth p
x
� 
N
%s
*synth26
"|      |Instance |Module |Cells |
2default:defaulth p
x
� 
N
%s
*synth26
"+------+---------+-------+------+
2default:defaulth p
x
� 
N
%s
*synth26
"|1     |top      |       |     9|
2default:defaulth p
x
� 
N
%s
*synth26
"+------+---------+-------+------+
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Writing Synthesis Report : Time (s): cpu = 00:00:09 ; elapsed = 00:00:10 . Memory (MB): peak = 1889.145 ; gain = 568.750 ; free physical = 46007 ; free virtual = 69439
2default:defaulth px� 
�
%s*synth2~
jSynthesis current peak Physical Memory [PSS] (MB): peak = 1308.850; parent = 1099.300; children = 209.581
2default:defaulth px� 
�
%s*synth2}
iSynthesis current peak Virtual Memory [VSS] (MB): peak = 2857.102; parent = 1889.148; children = 967.953
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
r
%s
*synth2Z
FSynthesis finished with 0 errors, 2 critical warnings and 3 warnings.
2default:defaulth p
x
� 
�
%s
*synth2�
�Synthesis Optimization Runtime : Time (s): cpu = 00:00:09 ; elapsed = 00:00:10 . Memory (MB): peak = 1889.145 ; gain = 568.750 ; free physical = 46011 ; free virtual = 69443
2default:defaulth p
x
� 
�
%s
*synth2�
�Synthesis Optimization Complete : Time (s): cpu = 00:00:09 ; elapsed = 00:00:10 . Memory (MB): peak = 1889.152 ; gain = 568.750 ; free physical = 46011 ; free virtual = 69443
2default:defaulth p
x
� 
B
 Translating synthesized netlist
350*projectZ1-571h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2.
Netlist sorting complete. 2default:default2
00:00:002default:default2
00:00:002default:default2
1895.0822default:default2
0.0002default:default2
461292default:default2
695622default:defaultZ17-722h px� 
K
)Preparing netlist for logic optimization
349*projectZ1-570h px� 
u
)Pushed %s inverter(s) to %s load pin(s).
98*opt2
02default:default2
02default:defaultZ31-138h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2.
Netlist sorting complete. 2default:default2
00:00:002default:default2
00:00:002default:default2
1974.7382default:default2
0.0002default:default2
460372default:default2
694692default:defaultZ17-722h px� 
~
!Unisim Transformation Summary:
%s111*project29
%No Unisim elements were transformed.
2default:defaultZ1-111h px� 
g
$Synth Design complete, checksum: %s
562*	vivadotcl2
17b233682default:defaultZ4-1430h px� 
U
Releasing license: %s
83*common2
	Synthesis2default:defaultZ17-83h px� 
�
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
172default:default2
32default:default2
22default:default2
02default:defaultZ4-41h px� 
^
%s completed successfully
29*	vivadotcl2 
synth_design2default:defaultZ4-42h px� 
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2"
synth_design: 2default:default2
00:00:122default:default2
00:00:112default:default2
1974.7382default:default2
654.3442default:default2
462392default:default2
696712default:defaultZ17-722h px� 
u
%s6*runtcl2Y
ESynthesis results are not added to the cache due to CRITICAL_WARNING
2default:defaulth px� 
�
 The %s '%s' has been generated.
621*common2

checkpoint2default:default2�
�/run/media/nicolas/Coisas/Work/mestrado/design_of_digital_systems/dds-group10/assignment 4/project_1/project_1.runs/synth_1/task2.dcp2default:defaultZ17-1381h px� 
�
%s4*runtcl2t
`Executing : report_utilization -file task2_utilization_synth.rpt -pb task2_utilization_synth.pb
2default:defaulth px� 
�
Exiting %s at %s...
206*common2
Vivado2default:default2,
Fri Sep 15 13:29:56 20232default:defaultZ17-206h px� 


End Record