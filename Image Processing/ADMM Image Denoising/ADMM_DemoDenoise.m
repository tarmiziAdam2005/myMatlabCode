% ================ Demo for grayscale image denoising==================
% This code demostrates the use of the ADMM Image denoising. ADMM is a
% splitting version of the more classical ALM (Augmented Lagrangian Method)
% This code solves the problem of
%       min_x  1/2*||y - x||^2_2 + lamda||Dx||_1

clc
clear all;
close all;

Img = double(imread('peppers.bmp')); %Your Image goes here

sigma = 15; % standard variation

%g = imnoise(Img,'gaussian',0,sigma^2/255^2);

g = Img +  sigma * randn(size(Img)); %Add a little noise

lam    = 5.50;


res     = cell([1 size(lam,2)]);
resSSIM = cell([1 size(lam,2)]); %Store SSIM result of each iteration
resPSNR = cell([1 size(lam,2)]); %Store PSNR result of each iteration
rho     = 1; %default 2
Nit     = 400;
tol     = 1e-5;

%=============Deblurr algorithm==========
%for k=1:length(lam)
    tg = tic;
    out = ADMM(g,Img,lam,rho,Nit,tol);
    tg = toc(tg);
    %res{1,k} = out;
    %resSSIM{1,k} = res{1,k}.ssimf;
    %resPSNR{1,k} = res{1,k}.psnrf;
%end
%========================================

%resSSIM = resSSIM';
%resPSNR = resPSNR';


figure;
imshow(uint8(out.sol));
title(sprintf('ALM Denoised (PSNR = %3.3f dB,SSIM = %3.3f, cputime %.3f s) ',...
                       out.psnrf, out.ssimf, tg));

figure;
imshow(uint8(g));
title(sprintf('Noisy (PSNR = %3.3f dB, SSIM = %3.3f)',  psnr_fun(g, Img),ssim_index(g,Img)));

figure;
imshow(uint8(Img));
title(sprintf('Original (PSNR = %3.3f dB)',  psnr(Img,Img)));

