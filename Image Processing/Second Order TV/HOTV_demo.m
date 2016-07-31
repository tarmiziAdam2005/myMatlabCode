clc
clear all;
close all;

Img = double(imread('Lighthouse256.bmp')); %Your Image goes here

N = numel(Img);
%H = ones(9,9)/81;
K = fspecial('gaussian', [9 9], 5); % Deblurring. Try other kernels as
                                     % well
%K     =   fspecial('average',1); % For denoising
f = imfilter(Img,K,'circular');

BSNR =30;
sigma = BSNR2WGNsigma(f, BSNR);

% If you dont have the BSNR2WGNsigma() function, use the below instead.

%sigma = sqrt(5);
%BSNR=20*log10(norm(f(:)-mean(f(:)),'fro')/sqrt(N)/sigma);

f = f +  sigma * randn(size(Img)); %Add a little noise



opts.lam       = 3500; % for deblurring, try large values.
opts.omega     = 50;  % reg param for 2nd order TV

%opts.lam       = 1.65; % for denoising try starting with these 
%opts.omega     = 12;  

opts.Nit       = 400;
opts.tol       = 1.0e-5;
opts.beta      = 1;

% ****** The main solver ******
out = HOTV(f,Img,K, opts);
%******************************

figure;
imshow(uint8(out.sol));
title(sprintf('2nd Order TV Deblurred (PSNR = %3.3f dB, cputime %.3f s) ',...
                       psnr_fun(uint8(out.sol),uint8(Img)), out.cpuTime));

figure;
imshow(uint8(f));
title(sprintf('Blurred + Noisy (PSNR = %3.3f dB)',psnr_fun(uint8(f),uint8(Img))));

figure;
imshow(uint8(Img));
title('Original');