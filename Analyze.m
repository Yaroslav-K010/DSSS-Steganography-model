clc;
clear;
close all;

original_wav = 'C:\Users\User\Desktop\audio\original.wav';
stego_wav    = 'C:\Users\User\Desktop\audio\stego.wav';
message_file = 'C:\Users\User\Desktop\audio\message.txt';

stego_key = 9999;
original_message_bytes = 24;

[y, Fs] = audioread(original_wav);
[x, ~]  = audioread(stego_wav);

y = double(y);
x = double(x);

if size(y,2) > 1
    y = y(:,1);
end

if size(x,2) > 1
    x = x(:,1);
end

signal_length = length(y);
total_bits = original_message_bytes * 8;

N = floor(signal_length / total_bits);
fprintf('N = %d\n', N);

extracted_bits = zeros(total_bits,1);

for i = 1:total_bits
    idx_start = (i-1)*N + 1;
    idx_end   = i*N;

    psp = PSP(N, stego_key + i);
    segment = x(idx_start:idx_end);

    r = sum(segment .* psp);
    extracted_bits(i) = r > 0;
end

fid = fopen(message_file,'r');
data = double(fread(fid,'uint8'));
fclose(fid);

bin_data = de2bi(uint8(data), 8, 'left-msb');
bitstream_orig = reshape(bin_data.', [], 1);
bitstream_orig = bitstream_orig(1:total_bits);

errors = sum(bitstream_orig ~= extracted_bits);
BER = errors / total_bits;

diff_signal = y - x;
MSE = mean(diff_signal.^2);

E = sum(diff_signal.^2) / sum(y.^2);

SNR_val = sum(y.^2) / sum(diff_signal.^2);

mA = max(abs(y));
PSNR_val = 20 * log10(mA / sqrt(E));

fprintf('========= STEGO ANALYSIS =========\n');
fprintf('BER  = %.6f\n', BER);
fprintf('MSE  = %.6f\n', MSE);
fprintf('E    = %.6f\n', E);
fprintf('SNR  = %.2f dB\n', 10 * log10(SNR_val));
fprintf('PSNR = %.2f dB\n', PSNR_val);

function psp = PSP(N, seed)
    a = 16807;
    m = 2147483647;

    M = zeros(N,1,'double');
    M(1) = mod(double(seed), m);

    for j = 2:N
        M(j) = mod(a * M(j-1), m);
    end

    bits = mod(M,2);
    psp = 2 * bits - 1;
end