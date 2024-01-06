# Traffic lights Finite State Machine in VHDL

This program implements a traffic light state machine on the Basys 3 development board.
The traffic light consist of a RED, YELLOW and GREEN LEDs for the car lights and a RED and GREEN LEDs for the pedestrian ligths.

## Functionality

This state machine mirrors from the french traffic lights system.

There are four states which are automatically cycled by default. But there is a pedestrian button fo force the transition between CARS_PASS and CARS_WARNING states.

| State name              | Pedestrians lights color | Cars lights color | Description                                                     |
|-------------------------|--------------------------|-------------------|-----------------------------------------------------------------|
| **PEDESTRIANS_PASS**    | GREEN                    | RED               | The pedestrians can pass, the cars can't                        |
| **PEDESTRIANS_WARNING** | RED                      | RED               | The pedestrians can't begin crossing because cars will soon pass |
| **CARS_WARNING**        | RED                      | YELLOW            | The cars needs stop to prepare for the pedestrians to pass            |
| **CARS_PASS**           | RED                      | GREEN             | The cars can pass, the pedestrians can't                        |

The delays can be adjusted by editing the default values in the `vhdl_traffic_lights/sources_1/TrafficLights.vhd` file. Or by mapping the generics in the `vhdl_traffic_lights/sources_1/fsm.vhd`.

```vhdl
Generic (
    pedestrians_delay_ms : INTEGER := 8000;   -- Time for the Pedestrians to pass (ms)
    warning_delay_ms : INTEGER := 4000;       -- Amount of time the traffic light stays in both warning states (ms)
    cars_delay_ms : INTEGER := 16000         -- Time for the cars to pass (ms)
);
```

## FSM Diagram

![FSM_Diagram](https://raw.githubusercontent.com/RedBlaze42/RP2040-C-TrafficLights/main/images/FSM_diagram.svg)

## Video demonstration

[Here is a video showing the project in action](https://youtu.be/PFj5QKF3p6s)

## Architecture

Firstly, the input clock is divided by 100 000 to create a 1 kHZ clock.
For this we use a simple counter that inverts the output clock every 50 000 ticks from the input clock. This inversion every half period creates a duty cycle of 0.5.

This clock and all the I/O is mapped to the TrafficLights component, which is the main logic of the circuit.

In the TrafficLights architecture, a single counter is incremented every millisecond. It will switch to the next state when reaching a defined count that depends on the current state. When switching to any state, this counter is reset.
The pedestrian button can also force the switch from CARS_PASS to CARS_WARNING.

The output LEDs are mapped using combinatorial logic.

## RTL Diagram

Here is the detailed RTL diagram of the circuit.

![https://raw.githubusercontent.com/RedBlaze42/FPGA-VHDL-TrafficLights/main/images/RTL_diagram.svg](https://raw.githubusercontent.com/RedBlaze42/FPGA-VHDL-TrafficLights/main/images/RTL_diagram.svg)

## Wiring

| Function          | PIN           |
|-------------------|---------------|
| Cars RED          | 1st LED       |
| Cars YELLOW       | 2nd LED       |
| Cars GREEN        | 3rd LED       |
| Pedestrians RED   | 15th LED      |
| Pedestrians GREEN | 16th LED      |
| Pedestrian button | CENTER button |
| System RESET      | UP button     |

The input clock is set at 100 MHz

## Logic ressources utilization

On the 

| Ref Name | Used | Functional Category |
|----------|------|---------------------|
| FDCE     |   50 |        Flop & Latch |
| LUT6     |   38 |                 LUT |
| LUT5     |   21 |                 LUT |
| OBUF     |   16 |                  IO |
| CARRY4   |   12 |          CarryLogic |
| LUT4     |   11 |                 LUT |
| LUT2     |    4 |                 LUT |
| IBUF     |    3 |                  IO |
| LUT3     |    2 |                 LUT |
| LUT1     |    2 |                 LUT |
| BUFG     |    2 |               Clock |
| FDRE     |    1 |        Flop & Latch |

So 74 Look Up Tables and 51 Flip-Flops after synthesis.
But optimized to 71 LUTs and 51 FFs after implementation.

## Simulation

### Clock divider testbench

### FSM testbench

#### Button not pressed

As we can see, after a reset period of one second, the state transitions and timings are respected.
![Simulation waveforms without pressing the button](https://github.com/RedBlaze42/FPGA-VHDL-TrafficLights/blob/main/images/test_bench_1.png?raw=true)

#### Button pressed
In this simulation, the pedestrian button is pressed. We can see that the timings and transitions are not altered except for the CARS_PASS state that lives only one cycle.
![Simulation waveforms when pressing the button](https://github.com/RedBlaze42/FPGA-VHDL-TrafficLights/blob/main/images/test_bench_2.png?raw=true)