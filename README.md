# 🔥 FPGA-Based Minimalistic Fighting Game

## 🎮 Overview

This project is a **minimalistic 2D fighting game** implemented entirely in **hardware using Verilog HDL** and deployed on an **FPGA development board**. Inspired by [Footsies](https://hifight.github.io/footsies/), an open-source fighting game by HiFight, this project focuses on core mechanics such as precise movement, hit detection, and timing — all realized without a software CPU.

The game supports **two players**, rendered in **real time** on a **VGA display**, with control handled through physical keypads. The goal is to reduce your opponent's health to zero through strategic movement and attacks.

This project reinforces core digital design principles such as:
- **Finite State Machines (FSMs)**
- **Real-time VGA graphics generation**
- **Input handling via keypads**
- **Hardware-based game logic and timing**
- **Modular design and system integration**

---

## 🧱 Features

- ⚔️ Two-player gameplay
- 📺 VGA display output (640x480 @ 60Hz)
- ⌨️ Physical keypad input for controls
- 💡 Real-time rendering and updates
- ❤️ Health bar and win condition
- 🔄 Reset and game loop control

---

## 🛠️ Requirements

- FPGA Development Board
- 4x4 Matrix Keypad
- VGA cable and display
- Verilog-compatible synthesis tool
- Clock source

---

## 🔧 Controls

**Player 1 (Buttons on the FPGA board):**
- `←` Move Left
- `→` Move Right
- `A` Attack

**Player 2 (Keypad):**
- `←` Move Left
- `→` Move Right
- `A` Attack

---

## 🕹️ Gameplay

- Players start at opposite sides of the arena.
- Move closer or away using directional controls.
- When in range, press the attack button to hit the opponent.
- A successful hit reduces the opponent's health.
- First to reduce opponent's health to zero wins.

---

