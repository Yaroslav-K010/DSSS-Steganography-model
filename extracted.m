clc;
clear;
close all;

input_wav   = 'output/stego.wav';
message_out = 'messageStego.txt';

stego_key = 9999;
original_message_bytes = 24;

[x, Fs] = audioread(input_wav);
x = double(x);

if size(x,2) > 1
    x = x(:,1);
end

signal_length = length(x);
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

ResData = zeros(original_message_bytes,1);

for i = 1:original_message_bytes
    bits = extracted_bits((i-1)*8+1:i*8);
    ResData(i) = bi2de(bits.','left-msb');
end

fid = fopen(message_out,'w');
fwrite(fid, uint8(ResData));
fclose(fid);

disp('Извлечение завершено.');

function psp = PSP(N, seed)
    a = 16807;
    m = 2147483647;

    M = zeros(N,1,'double');
    M(1) = mod(double(seed), m);

    for j = 2:N
        M(j) = mod(a * M(j-1), m);
    end

    bits = mod(M,2);
    psp = 2*bits - 1;
end