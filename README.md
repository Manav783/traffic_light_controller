# Traffic Light Controller
This project implements a 4-way traffic light controller using Verilog HDL, based on an 8-state Finite State Machine (FSM). The design supports straight and right-turn signals for both North–South (NS) and East–West (EW) directions with adaptive timing using vehicle presence inputs.

## Design Overview
- FSM-based traffic light controller
- Handles straight + right turn lanes
- Uses real-time second counting from a 100 MHz FPGA clock
- Dynamically switches phases based on minimum, maximum, and sensor-triggered timing

## Timing Strategy 
- 'G_min' : Minimum green time
- 'G_max' : Maximum green time
- 'Y_sec' : Yellow duration
- Green lights stay active for at least G_min
- Transition happens early if opposing traffic is detected
- Forced transition after 'G_max' even if no request
