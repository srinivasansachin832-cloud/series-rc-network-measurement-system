% EECE 2080 Basic EE Lab II - Course Project
% Name: Sachin Srinivasan
% Date: 04-22-2026
%
% Description:
% This script is tailored to the uploaded ADK CSV file named
% "channel 1.csv". It imports the exported data, plots both measured
% voltages versus time on one graph, and calculates the values of an
% unknown series RC network.
%
% Circuit assumption:
% ADK W1 -> unknown series RC -> Node A -> Rsense -> ground
%
% Probe assumption:
% Channel 1 measures Vs across Rsense
% Channel 2 measures Vin at the input node
%
% This version is for the main project only.
% No bonus features are included.
% The frequency is fixed at 2000 Hz.

clear; clc; close all;

csvFileName = 'channel 1.csv';
senseResistor_Ohms = 10000;
inputFrequency_Hz = 2000;
angularFrequency_rad_per_s = 2 * pi * inputFrequency_Hz;

importOptions = detectImportOptions(csvFileName, 'FileType', 'text');
importOptions.CommentStyle = '#';
dataTable = readtable(csvFileName, importOptions);

time_s = dataTable{:,1};
vSense_V = dataTable{:,2};
vIn_V = dataTable{:,3};

time_s = time_s(:);
vSense_V = vSense_V(:);
vIn_V = vIn_V(:);

validRows = ~(isnan(time_s) | isnan(vSense_V) | isnan(vIn_V));
time_s = time_s(validRows);
vSense_V = vSense_V(validRows);
vIn_V = vIn_V(validRows);

[time_s, uniqueIndices] = unique(time_s, 'stable');
vSense_V = vSense_V(uniqueIndices);
vIn_V = vIn_V(uniqueIndices);

if numel(time_s) < 10
    error('Not enough numeric data points were found in the CSV file.');
end

figure;
plot(time_s, vIn_V, 'LineWidth', 1.3); hold on;
plot(time_s, vSense_V, 'LineWidth', 1.3);
grid on;
title('Imported ADK Voltage Data');
xlabel('Time (s)');
ylabel('Voltage (V)');
legend('Input voltage V_{in}(t)', 'Sense resistor voltage V_s(t)', 'Location', 'best');

Vin_phasor = fitPhasor(time_s, vIn_V, angularFrequency_rad_per_s);
Vs_phasor = fitPhasor(time_s, vSense_V, angularFrequency_rad_per_s);

current_phasor_A = Vs_phasor / senseResistor_Ohms;
vUnknown_phasor = Vin_phasor - Vs_phasor;
zUnknown_Ohms = vUnknown_phasor / current_phasor_A;

unknownResistance_Ohms = real(zUnknown_Ohms);
unknownReactance_Ohms = imag(zUnknown_Ohms);

if unknownReactance_Ohms >= 0
    error(['The reactance was not negative. Check the wiring, ', ...
           'the probe placement, and whether the unknown load is a series RC network.']);
end

unknownCapacitance_F = -1 / (angularFrequency_rad_per_s * unknownReactance_Ohms);

inputVoltagePeak_V = abs(Vin_phasor);
senseVoltagePeak_V = abs(Vs_phasor);
currentPeak_A = abs(current_phasor_A);
impedanceAngle_deg = rad2deg(angle(zUnknown_Ohms));

fprintf('EECE 2080 Project Results\n');
fprintf('CSV file used: %s\n', csvFileName);
fprintf('Input frequency: %.3f Hz\n', inputFrequency_Hz);
fprintf('Known sense resistor: %.3f k%c\n', senseResistor_Ohms/1000, 937);

fprintf('\nMeasured and calculated values\n');
fprintf('Input voltage amplitude: %.4f V peak\n', inputVoltagePeak_V);
fprintf('Sense resistor voltage amplitude: %.4f V peak\n', senseVoltagePeak_V);
fprintf('Current amplitude: %.6e A peak\n', currentPeak_A);
fprintf('Unknown impedance: %.2f %+.2fj %c\n', real(zUnknown_Ohms), imag(zUnknown_Ohms), 937);
fprintf('Impedance angle: %.3f degrees\n', impedanceAngle_deg);

fprintf('\nFinal component values\n');
fprintf('Unknown resistance: %.3f k%c\n', unknownResistance_Ohms/1000, 937);
fprintf('Unknown capacitance: %.3f nF\n', unknownCapacitance_F * 1e9);

function phasorValue = fitPhasor(time_s, signal_V, angularFrequency_rad_per_s)
    designMatrix = [cos(angularFrequency_rad_per_s * time_s), ...
                    sin(angularFrequency_rad_per_s * time_s), ...
                    ones(size(time_s))];

    coefficients = designMatrix \ signal_V;

    a = coefficients(1);
    b = coefficients(2);

    phasorValue = a - 1j*b;
end

