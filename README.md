# Design and FPGA Implementation of Parameterizable RSA Accelerator based on Montgomery Algorithm

## Project Overview
This project focuses on the design and FPGA implementation of a parameterizable RSA (Rivest-Shamir-Adleman) accelerator using the Montgomery algorithm. The RSA algorithm is widely used for secure communication and data encryption. The Montgomery algorithm is employed to optimize modular multiplication, a fundamental operation in RSA.
The implementation is done using VHDL, and the Xilinx Vivado tool is used for synthesis and implementation on an FPGA (PYNQ board). 
The design is parameterizable, allowing users to customize the number of cores and the bit width of input messages.

## Branches for Exponentiation Algorithms:
+ lr-exponentiation: Implements the Left-To-Right Modular Exponentiation algorithm.
+ rl-exponentiation: Implements the Right-To-Left Modular Exponentiation algorithm
The first solution is more area efficient, providing approximately 65% less area.
The second solution has higher performance, offering about 50% more performance on average.
It is recommended to use one of those branches because they are more updated than main.

## Directory Structure of lr-exponentiation and rl-exponentiation
+ The RTL is found under this path: Project/rsa_integration_kit/Exponentiation/source.
  + MonPro: performs Modular Multiplication
  + MonExp: performs Modular Exponentiation
  + exponentiation: wrapper for multi-cores of MonExp 
+ There are testbenches for the multiplication and exponentiation modules under this path: Project/tb
+ High level models of the algorithms is found under this path: Project/models
+ The microarchitecture of the RL-Exponentiation is found in the rl-exponentiation branch under: Project/Microarchitecture-RL-Updated.pdf
  + The main difference in the LR algorithm is the use of only 1 MonPro instance.
