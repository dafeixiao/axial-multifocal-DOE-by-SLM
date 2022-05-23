
%% ground truth
% introduction to Forier Optics--4.5.1 Fresnel Diffraction by a Square Aperture

lambda = 532e-6;
N = 512;
x = linspace(-1,1,N);
[x, y] = meshgrid(x,x);

%% Gaussian illumination
sigma = 1.5;
G = 1/(2*pi*sigma^2)*exp(-(x.^2+y.^2)/2*sigma^2);
G = mat2gray(G);
% imshow(G,[]);

%%
U1 = zeros(N);
U1(sqrt(x.^2+y.^2)<0.2) = 1;
z = 100;
% width = 10;
width = sqrt(N*lambda*z); % same size for two methods
deltax = width/N;

% U2A = AngularSpectrumPropagation(U1, deltax, z, lambda);
% figure(); imshow(abs(U2A),[]);
[U2F, size1] = FresnelDiffractionIntegral(U1, deltax, z, lambda,"1");
figure(); imshow(abs(U2F),[])
[U2FC, size2] = FresnelDiffractionIntegral(U1, deltax, z, lambda,"conv");
figure(); imshow(abs(U2FC),[])
% error = abs(U2F-U2FC);
% figure(); imshow(error,[]);










