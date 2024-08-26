# DESIGN-OF-ASYNCHRONOUS-FIFO

Asynchronous buffer enables data transfer between different clock domains without synchronizing data read and data write clocks,crucial for maintaining coherence in digital systems.

This project is mainly focus on build an asynchronous fifo in verilog and make further optimizationFIFO means first in first out. a method for organizing and manipulating a data buffer. FIFOs are commonly used in electronic circuits for buffering and flow control between hardware and software. In its hardware form, a FIFO primarily consists of a set of read and write pointers, storage and control logic. Storage may be static random access memory (SRAM), flip-flops, latches or any other suitable form of storage. For FIFOs of non-trivial size, a dual-port SRAM is usually used, where one port is dedicated to writing and the other to reading.

FIFOs are often used to safely pass data from one clock domain to another asynchronous clock domain. FIFO can also used between different date width.
