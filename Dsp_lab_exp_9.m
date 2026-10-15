clc; clear; close all;
 
%% PARAMETERS
A = 1; f = 50; Fs = 1000; N = 1000;
n = 0:N-1; x = A*sin(2*pi*f*n/Fs);
B = 8; bits = [4 8 12 16];
 
%% 8-BIT QUANTIZATION
D = 2*A/2^B;
 
xr = D*round(x/D);          % Rounding
xt = D*fix(x/D);            % Truncation
 
er = x - xr;                % Rounding error
et = x - xt;                % Truncation error
 
SQr = 10*log10(mean(x.^2)/mean(er.^2));
SQt = 10*log10(mean(x.^2)/mean(et.^2));
 
%% INPUT / OUTPUT QUANTIZATION
xq = xr;
y = x;
yq = D*round(y/D);
eo = y - yq;
SQout = 10*log10(mean(y.^2)/mean(eo.^2));
 
%% WORD-LENGTH COMPARISON
step  = zeros(1, length(bits));
sqnrR = zeros(1, length(bits));
sqnrT = zeros(1, length(bits));
maxER = zeros(1, length(bits));
maxET = zeros(1, length(bits));

for k = 1:length(bits)
    b = bits(k);
    d = 2*A/2^b;
    qr = d*round(x/d);
    qt = d*fix(x/d);
    er1 = x - qr; et1 = x - qt;
 
    step(k)  = d;
    sqnrR(k) = 10*log10(mean(x.^2)/mean(er1.^2));
    sqnrT(k) = 10*log10(mean(x.^2)/mean(et1.^2));
    maxER(k) = max(abs(er1));
    maxET(k) = max(abs(et1));
end
 
%% RESULTS DISPLAY
fprintf('\n========== QUANTIZATION RESULTS ==========\n');
fprintf('Amplitude = %.1f | Frequency = %d Hz | Fs = %d Hz\n',A,f,Fs);
fprintf('Samples = %d | Main word length = %d bits\n',N,B);
fprintf('8-bit Step Size = %.7f\n',D);
fprintf('Rounding SQNR = %.4f dB\n',SQr);
fprintf('Truncation SQNR = %.4f dB\n',SQt);
fprintf('Output SQNR = %.4f dB\n',SQout);
fprintf('Max Rounding Error = %.6f\n',max(abs(er)));
fprintf('Max Truncation Error = %.6f\n',max(abs(et)));
 
%% WORD-LENGTH TABLE
T2 = table(bits', step', sqnrR', sqnrT', maxER', maxET', ...
    'VariableNames', {'Bits','StepSize','SQNR_Round_dB','SQNR_Trunc_dB','MaxError_Round','MaxError_Trunc'});
disp(T2);
 
%% OUTPUT PARAMETER TABLE
Parameter = {
    'Quantized signal'
    'Quantization error'
    'SQNR'
    'Word-length comparison'
};
 
Observation = {
    sprintf('8-bit rounding, Delta = %.7f', D)
    sprintf('Max rounding error = %.6f', max(abs(er)))
    sprintf('Rounding = %.4f dB; Truncation = %.4f dB', SQr, SQt)
    'SQNR increases as word length increases'
};
 
Unit = {
    'Amplitude'
    'Amplitude'
    'dB'
    'Bits / dB'
};
 
disp(table(Parameter, Observation, Unit));
 
%% GRAPHS
figure('Name', 'Quantized Signal');
plot(n(1:100), x(1:100)); hold on;
stairs(n(1:100), xr(1:100));
grid on; xlabel('Sample n'); ylabel('Amplitude');
title('Original and 8-bit Quantized Signal');
legend('Original','Quantized');
 
figure('Name', 'Quantization Error');
plot(n, er); hold on; plot(n, et);
grid on; xlabel('Sample n'); ylabel('Error');
title('Rounding and Truncation Quantization Error');
legend('Rounding','Truncation');
 
figure('Name', 'SQNR vs Word Length');
plot(bits, sqnrR, 'o-'); hold on;
plot(bits, sqnrT, 's--');
grid on; xlabel('Word Length (bits)'); ylabel('SQNR (dB)');
title('SQNR vs Word Length');
legend('Rounding','Truncation');
 
figure('Name', 'Error vs Word Length');
semilogy(bits, maxER, 'o-'); hold on;
semilogy(bits, maxET, 's--');
grid on; xlabel('Word Length (bits)'); ylabel('Maximum Quantization Error');
title('Quantization Error vs Word Length');
legend('Rounding','Truncation');