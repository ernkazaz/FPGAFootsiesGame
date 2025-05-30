# 🔥 FPGA-Based Minimalistic Fighting Game (Footsies-Inspired)

## 🎮 Overview

This project implements a **2D fighting game** called *Footsies* on the **DE1-SoC FPGA development board** using **Verilog HDL**. The game features **two playable characters**, each capable of **moving**, **attacking**, **blocking**, and transitioning through defined states using finite state machines (FSMs). It supports **Player-vs-Player** and **Player-vs-CPU** modes.

All gameplay logic — including input handling, attack resolution, and rendering — is done purely in hardware. The game visuals are displayed using a **VGA output at 640x480 resolution and 60Hz**, leveraging a custom VGA controller derived from V. Hunter Adams’ implementation.

---

## 🧱 Features

- ⚔️ Two-player fighting gameplay
- 🧠 FSM-controlled character behavior
- 📺 Real-time 60Hz VGA output (640x480)
- ⌨️ Controls: On-board buttons for Player 1, matrix keypad for Player 2
- ❤️ Health tracking and block counters
- 🔄 Smooth animations and real-time game loop
- 🧪 Hardware-level FSM testbench for debugging state transitions

---

## 🧪 FSM Testing

To validate state transitions such as `Idle`, `MoveLeft`, `MoveRight`, `AttackStart`, `AttackActive`, and `AttackRecovery`, we created a **Cocotb-based testbench**. This helped us debug unexpected behavior by comparing actual FSM outputs with expected values and ensured the directional attack flag and normal attack flags behaved correctly across transitions.

---

## 🕹️ Gameplay Logic

- Players start on opposite sides of the screen.
- Movement and attacks are managed by FSMs and restricted to screen boundaries.
- Characters perform **normal** or **directional** attacks depending on input.
- The game ends when one player’s health reaches zero.
- CPU-controlled mode includes simple AI logic for movement and attack.

---

## 🖥️ VGA Display System

The VGA controller generates `HSYNC` and `VSYNC` pulses along with pixel coordinates for each frame:

- **Resolution:** 640x480 @ 60 Hz
- **Pixel Clock:** 25.175 MHz
- **Timing Parameters:**
  - Horizontal: 800 cycles (640 visible + front porch + sync + back porch)
  - Vertical: 525 lines (480 visible + front porch + sync + back porch)

Game logic dynamically determines pixel colors based on the current state, player positions, and UI elements, enabling a CPU-less hardware rendering pipeline.

---

## 🧱 Technical Fixes

**Character Movement Boundary Fix:**  
We initially bounded movement between 0–640 pixels. However, character step size (2–3 pixels/frame) allowed them to overflow off-screen. We adjusted the limits slightly inward to reliably constrain character motion within screen bounds.

---

## 🛠️ Requirements

- DE1-SoC FPGA Board
- 4x4 Matrix Keypad (Player 2 control)
- VGA monitor and cable
- Verilog toolchain (e.g., Quartus, ModelSim)
- Clock input (e.g., 50MHz)

---

## 🔧 Controls

**Player 1 (On-board Buttons):**
- `←` Move Left  
- `→` Move Right  
- `A` Attack  

**Player 2 (Matrix Keypad):**
- `←` Move Left  
- `→` Move Right  
- `A` Attack  

---



