# Traffic Light Controller
This project implements a 4-way traffic light controller using Verilog HDL, based on an 8-state Finite State Machine (FSM). The design supports straight and right-turn signals for both North–South (NS) and East–West (EW) directions with adaptive timing using vehicle presence inputs.
This Verilog module implements a 4-way traffic light controller using an 8-state finite state machine. A 100 MHz clock is divided to generate a 1-second tick, which drives all timing decisions. Each FSM state represents a specific traffic phase (straight or right-turn for NS or EW), with green, yellow, and red outputs assigned accordingly. A second counter enforces minimum and maximum green times, while vehicle presence inputs (ns and ew) allow early transitions when opposing traffic is detected. State changes occur only on the 1-second tick, ensuring accurate real-time behavior, safe yellow intervals, and fair, adaptive traffic flow across all directions.

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

## Sensor Inputs
- ns : Vehicle present in NS direction
- ew : Vehicle present in EW direction
These inputs allow adaptive traffic control instead of fixed timing.

## Inputs
- clk : 100 MHz system clock
- rst : Synchronous reset
- ns, ew : Traffic request signals
  
## Outputs 
3-bit encoded
NS_str : NS straight light
NS_right : NS right-turn light
EW_str : EW straight light
EW_right : EW right-turn light

## Light Encoding
100 → Red
010 → Yellow
001 → Green

## Key Implementation Highlights
- Clock Divider generates a precise 1-second tick
- State & second counter update only on second ticks
- Clean separation of: State register, Next-state logic and Output logic
- Fully synthesizable and FPGA-friendly
