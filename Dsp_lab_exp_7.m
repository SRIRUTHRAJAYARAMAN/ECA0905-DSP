clear; clc; close all;

Fs = 10000;
fp = 1500;
fs = 2000;
N = 40; % Filter order

% 1. Parks-McClellan (Equiripple) Design
f_bands = [0, fp, fs, Fs/2] / (Fs/2); % Normalized frequency band edges
a_bands = [1, 1, 0, 0];               % Desired amplitudes
b_pm = firpm(N, f_bands, a_bands);

% 2. Frequency-Sampling Design
b_fs = fir2(N, f_bands, a_bands);

% ==========================================
% DISPLAY NUMERICAL OUTPUTS IN COMMAND WINDOW
% ==========================================
fprintf('=== EXPERIMENT 7: PARKS-MCCLELLAN vs FREQUENCY SAMPLING ===\n\n');
fprintf('Filter Order (N): %d\n', N);
fprintf('Passband Edge: %d Hz, Stopband Edge: %d Hz\n\n', fp, fs);

fprintf('--- PARKS-MCCLELLAN COEFFICIENTS (b_pm, First 10) ---\n');
disp(b_pm(1:10));

fprintf('--- FREQUENCY-SAMPLING COEFFICIENTS (b_fs, First 10) ---\n');
disp(b_fs(1:10));

% Frequency Responses
[H_pm, f] = freqz(b_pm, 1, 1024, Fs);
[H_fs, ~] = freqz(b_fs, 1, 1024, Fs);

% Plotting
figure('Name', 'Parks-McClellan vs Frequency-Sampling');
subplot(2,1,1);
plot(f, 20*log10(abs(H_pm)), 'b', 'LineWidth', 1.5); hold on;
plot(f, 20*log10(abs(H_fs)), 'r--', 'LineWidth', 1.5); grid on;
legend('Parks-McClellan (Equiripple)', 'Frequency-Sampling');
title(['FIR Filter Magnitude Response Comparison (Order N = ', num2str(N), ')']);
xlabel('Frequency (Hz)'); ylabel('Magnitude (dB)'); ylim([-80 10]);

subplot(2,1,2);
plot(f, angle(H_pm)*180/pi, 'b', 'LineWidth', 1.5); hold on;
plot(f, angle(H_fs)*180/pi, 'r--', 'LineWidth', 1.5); grid on;
legend('Parks-McClellan', 'Frequency-Sampling');
title('Phase Response Comparison');
xlabel('Frequency (Hz)'); ylabel('Phase (degrees)');