# I2C
Design and Verification I2C memory
# I2C Protocol Verification using SystemVerilog UVM

## 📌 Overview

This project implements and verifies an I²C (Inter-Integrated Circuit) protocol-based communication system using SystemVerilog and UVM. The design includes a custom I2C Master, Slave Interface Controller, and a separate Memory module. The verification testbench covers both read and write operations, ensuring full protocol compliance.

## 🧠 Key Features

- I2C Master with FSM-based control
- I2C Slave with protocol decoding and memory access
- External 128x8 memory module
- Support for 7-bit addressing
- Read and Write operations
- Protocol-compliant Start, Stop, ACK/NACK handling
- Fully automated UVM-based testbench

---

## 🔧 Modules

### 🔹 I2C Master

- Initiates communication and controls clock (SCL)
- FSM-based operation: `IDLE`, `START`, `SEND_ADDR`, `GET_ACK`, `SEND_DATA`/`READ_DATA`, `COMPLETE`
- Supports both write (`wr = 1`) and read (`wr = 0`) operations
- Asserts `done` signal upon successful transaction
- Inputs: `addr[6:0]`, `din[7:0]`, `wr`, `rst`, `scl`
- Outputs: `datard[7:0]`, `done`

### 🔹 I2C Slave

- Detects start condition and receives address + R/W bit
- Sends/receives data through SDA
- Interfaces with external memory module
- FSM-based protocol handling: `IDLE`, `START`, `GET_ADDR`, `SEND_ACK`, `GET_DATA`, `SEND_DATA`, `COMPLETE`

### 🔹 Memory Module

- 128-byte x 8-bit synchronous memory
- Write: Uses `write_enable`, `address`, and `data_in`
- Read: Uses `read_enable` and returns `data_out`

---

## 🧪 Testbench

- Developed in SystemVerilog using UVM methodology
- Simulates reset, write, and read sequences
- Generates random 7-bit addresses and 8-bit data using `$random`
- Functional coverage with scoreboard and monitor:
  - Scoreboard maintains reference memory
  - Monitor tracks transactions and broadcasts packets
  - Automatic comparison of read data vs. expected

### ✔️ Pass Criteria

- Write data to a random address
- Read back from the same address
- Match read data with written data
- All test sequences pass, confirmed via simulator waveform

---

## 📷 Simulation Snapshots

- ✅ Single write to memory
- ✅ Single read from memory
- ✅ All sequences passed with data integrity

---

## 🛠️ Tools Used

- **Language**: SystemVerilog
- **Simulation**: Vivado
- **Verification Methodology**: UVM
