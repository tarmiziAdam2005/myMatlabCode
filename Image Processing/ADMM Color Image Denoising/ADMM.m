function out = ADMM(y,Img,lam,rho,Nit,tol)
% created by Tarmizi Adam 16/5/2016
%Update: 26/5/2016
%Update: 15/6/2016 added rho updating for accelerating convergence.
%        rho updating reference: 
%         - Chan, Stanley H., Ramsin Khoshabeh, Kristofor B. Gibson, Philip E. Gill, and 
%           Truong Q. Nguyen. "An augmented Lagrangian method for video restoration." In 
%           Acoustics, Speech and Signal Processing (ICASSP), 2011 IEEE International 
%           Conference on, pp. 941-944. IEEE, 2011.
      
% ADMM image denoising. This script solve the optimization problem
%
%    min_x  1/2*||y - x||^2_2 + lamda||Dx||_1

%Dependencies: this code depends on the function 
% psnr_fun(x, Img) and ssim_index(x,Img) for computing the PSNR and SSIM
% of the resulting denoised image. This function can be replaced by other 
% PSNR or SSIM function that you have.

[row,col] = size(y);
x         = y;
alpha     = 0.7;
v1        = zeros(row,col); %Initialize intermediate variables for v subproblem
v2        = zeros(row,col); %     "       "           "       for v subproblem

y1        = zeros(row,col); %Initialize Lagrange Multipliers
y2        = zeros(row,col); %   "       Lagrange Multipliers

relError     = zeros(Nit,1); % Compute error relative to the previous iteration.
relErrorImg  = relError;     %Compute error relative to the original image
psnrGain     = relError;     % PSNR improvement every iteration
funcVal      = relError;     %Function value at each iteration

eigDtD  = abs(fft2([1 -1], row, col)).^2 + abs(fft2([1 -1]', row, col)).^2;

[D,Dt]      = defDDt(); %Declare forward finite difference operators
[Dx1, Dx2] = D(x);

curNorm = sqrt(norm(Dx1(:) - v1(:),'fro'))^2 + sqrt(norm(Dx2(:) - v2(:),'fro'))^2;

tg = tic;

for k=1:Nit
    
    x_old = x;
    rhs = y - rho*Dt(y1/rho + v1, y2/rho + v2);
    lhs = 1 + rho*(eigDtD);
    
    x = fft2(rhs)./lhs;
    x = real(ifft2(x));
    
    [Dx1, Dx2]  = D(x);
    
    u1          = Dx1 + y1/rho;
    u2          = Dx2 + y2/rho;
    
    v1          = shrink(u1, lam/rho); %lam/rho
    v2          = shrink(u2, lam/rho);
    
    y1          =  y1 - rho*(v1 - Dx1);
    y2          =  y2 - rho*(v2 - Dx2);
    
    relError(k)    = norm(x - x_old,'fro')/norm(x, 'fro');
    r1          = x-y;
    funcVal(k)  = (1/2)*norm(r1,'fro')^2 + lam*sum(Dx1(:) + Dx2(:));
    
    % ****Update the rho at each iteration to accelerate the convergence***
    % Compare the acceleration with and without the rho updating.
    normOld = curNorm;
    curNorm = sqrt(norm(Dx1(:) - v1(:),'fro'))^2 + sqrt(norm(Dx2(:) - v2(:),'fro'))^2;
    % **********Update rho condition starts here *****************
    if curNorm > alpha*normOld
        rho = 0.5*rho;
    end
    %*************************************************************
    
    if relError(k) < tol
          break
    end
       
end

tg = toc(tg);

out.sol                 = x;                %Deblurred image
out.functionValue       = funcVal(1:k);
out.relativeError       = relError(1:k);
out.cpuTime             = tg;
out.finalRho            = rho;

end

function [D,Dt] = defDDt()
D  = @(U) ForwardDiff(U);
Dt = @(X,Y) Dive(X,Y);
end

function [Dux,Duy] = ForwardDiff(U)
 Dux = [diff(U,1,2), U(:,1,:) - U(:,end,:)];
 Duy = [diff(U,1,1); U(1,:,:) - U(end,:,:)];
end

function DtXY = Dive(X,Y)
  % Transpose of the forward finite difference operator
  % is the divergence fo the forward finite difference operator
  DtXY = [X(:,end) - X(:, 1), -diff(X,1,2)];
  DtXY = DtXY + [Y(end,:) - Y(1, :); -diff(Y,1,1)];   
end

function z = shrink(x,r)
z = sign(x).*max(abs(x)- r,0);
end

