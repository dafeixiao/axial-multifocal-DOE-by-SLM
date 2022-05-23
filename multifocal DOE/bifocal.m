
% Generation of axial bifocal DOE with fa=30mm and fb=34mm
% Method: nonlinear-function-based method
M = 1080;
N = 1920;
pixelSize = 6.3e-3; % SLM parameter
lambda = 532e-6; % wavelength
k = 2*pi/lambda; 
x = linspace(-pixelSize*N/2, pixelSize*N/2, N);
y = linspace(-pixelSize*M/2, pixelSize*M/2, M);
[x, y] = meshgrid(x, y);

f1 = 510; % DOE part
f2 = 31.875; % normal lens
phi1 = mod(k*(x.^2+y.^2)/(2*f1), 2*pi);
nonLinearPhi1 = phi1;   
nonLinearPhi1(phi1<pi) = 0;
nonLinearPhi1(phi1>=pi) = pi;
imshow(nonLinearPhi1,[]);

phi2 = k*(x.^2+y.^2)/(2*f2);
phi2 = mod(phi2, 2*pi);
% imshow(phi2, []);

phi = nonLinearPhi1+phi2;
imshow(phi,[]);
imwrite(phi,'bifocal_v1.jpg');






