clc;
clear;
close all;

input_wav  = 'input/original.wav';
output_wav = 'output/stego.wav';
message_in = 'input/message.txt';

alpha = 0.005;
stego_key = 9999;

[y, Fs] = audioread(input_wav);
y = double(y);

if size(y,2) > 1
    y = y(:,1);
end

signal_length = length(y);

fid = fopen(message_in,'r');
if fid == -1
    error('Failed to open message file');
end

Data = double(fread(fid,'uint8'));
fclose(fid);

message_bytes = length(Data);
fprintf('Message length: %d bytes\n', message_bytes);

BinData = de2bi(uint8(Data),8,'left-msb');
[m,n] = size(BinData);
total_bits = m*n;

N = floor(signal_length / total_bits);

if N < 1
    error('Container too small');
end

fprintf('N = %d\n',N);

Stega = y;

bitstream = reshape(BinData.',[],1);
bitstream = double(bitstream);

for i = 1:total_bits
    
    idx_start = (i-1)*N + 1;
    idx_end   = i*N;
    
    psp = PSP(N, stego_key + i);
    b = 2*bitstream(i) - 1;
    
    Stega(idx_start:idx_end) = ...
        y(idx_start:idx_end) + alpha * b * psp;
end

if total_bits*N < signal_length
    Stega(total_bits*N+1:end) = y(total_bits*N+1:end);
end

audiowrite(output_wav, Stega, Fs);

noise = Stega - y;
SNR = 10*log10(sum(y.^2)/sum(noise.^2));
fprintf('SNR = %.2f dB\n',SNR);

disp('Embedding complete.');

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