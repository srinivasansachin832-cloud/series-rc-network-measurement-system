# Series RC Network Measurement System

A breadboard-based measurement system that uses the Analog Discovery Kit and MATLAB to identify unknown resistor and capacitor values in a series RC network.

## Overview
This project was developed to characterize an unknown two-terminal series RC network by applying an AC signal, measuring circuit voltages, and extracting component values through MATLAB-based impedance analysis.

A known sense resistor is placed in series with the unknown network. The Analog Discovery Kit generates the sinusoidal input signal and captures the voltage across the sense resistor and the total input voltage. These measurements are exported to CSV and processed in MATLAB to determine the unknown resistance and capacitance.

## Features
- Breadboard-based test circuit for unknown series RC loads
- Analog Discovery Kit waveform generation and voltage measurement
- CSV-based waveform export and MATLAB post-processing
- Resistance and capacitance extraction using phasor and impedance analysis
- Plotting of imported waveform data

## Engineering Concepts Used
- AC steady-state analysis
- Phasors
- Impedance modeling
- Ohm’s Law
- Kirchhoff’s Voltage Law
- MATLAB data import and signal analysis
- Breadboard prototyping and circuit debugging

## Files
- `rc_identifier.m` - MATLAB script for importing waveform data and calculating unknown R and C values
- `docs/final-report.pdf` - full project report
- `images/` - circuit and waveform visuals
- `data/` - sample exported CSV data

## Measurement Method
The system uses the following circuit model:

ADK W1 -> unknown series RC -> Node A -> Rsense -> ground

With:
- Channel 1 measuring the voltage across the sense resistor
- Channel 2 measuring the input voltage

The MATLAB analysis computes:
- circuit current from the sense resistor voltage
- voltage across the unknown network
- unknown impedance
- resistance from the real part of impedance
- capacitance from the negative imaginary reactance

## Example Workflow
1. Connect the unknown series RC network to the breadboard fixture
2. Apply a sinusoidal input using the Analog Discovery Kit
3. Measure the input voltage and sense resistor voltage
4. Export the captured data to CSV
5. Run the MATLAB script
6. Read the calculated resistance and capacitance values

## Notes
This project was originally developed as a Circuit Theory II course project and later cleaned up for portfolio use.
