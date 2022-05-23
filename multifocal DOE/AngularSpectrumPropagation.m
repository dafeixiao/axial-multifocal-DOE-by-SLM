function [U2] = AngularSpectrumPropagation(U1, deltax, z, lambda)
% diffraction expressed by angular spectrum propagation
% the planes before and after propagation have the same size!!!
N = length(U1); % simulation size
maxFre = 1/deltax/2; % maximum frequency 
fx = linspace(-maxFre,maxFre,N); 
[fx, fy] = meshgrid(fx,fx); % frequency distribution
H = exp(1i*2*pi*z/lambda*sqrt(1-(lambda*fx).^2-(lambda*fy).^2)); 
H(fx.^2+fy.^2>=1/(lambda^2)) = 0; % transfer function

U1Fre = fftshift(fft2(ifftshift(U1))); 
U2Fre = U1Fre.*H; 
U2 = fftshift(ifft2(ifftshift(U2Fre)));

end

