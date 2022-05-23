function [U2, U2Size] = FresnelDiffractionIntegral(U1, deltax, z, lambda, mark)
% diffraction expressed by Fresnel's theory
% The sizes of the plane before and after propagation are different in 
% non-convolutional scheme!
% The two methods are consistent in engergy distribution, but not
% consistent in value for some unkown reasons.
% Fresnel diffraction integral is the approximation of Angular spectrum
% propagation

N = length(U1); % The simulation size
k = 2*pi/lambda; % wave number
x1 = linspace(-N/2*deltax, N/2*deltax, N);  
[x1, y1] = meshgrid(x1, x1); % x and y coordinates

if mark ~= "conv" % non-convolutional method-->integral method
    UU1 = U1.*exp(1i*k/(2*z)*(x1.^2+y1.^2));
    UU1Fre = fftshift(fft2(ifftshift(UU1)));
    maxFre = 1/deltax/2; % maximum frequency
    fre = linspace(-maxFre, maxFre, N); % frequency distribution
    x2 = fre*lambda*z;
    U2Size = max(x2)-min(x2);
    [x2, y2] = meshgrid(x2, x2); % Cartesian coordinates on the output plane
    U2 = exp(1i*k*z)/(1i*lambda*z)*exp(1i*k/(2*z)*(x2.^2+y2.^2)).*UU1Fre;
      
else % convolution method
    h = exp(1i*k*z)/(1i*lambda*z)*exp(1i*k/(2*z)*(x1.^2+y1.^2)); % point spread function
    U1Fre = fftshift(fft2(ifftshift(U1))); 
    hFre = fftshift(fft2(ifftshift(h))); % transfer function
    U2Fre = U1Fre.*hFre; % convolution in spatial domain corresponds to multiplication 
    U2 = fftshift(ifft2(ifftshift(U2Fre)));
    U2Size = deltax*N;
    
end

end

