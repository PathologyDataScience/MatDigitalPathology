function LAB = RGB2LAB(RGB)
%Converts RGB image to LAB colorspace.

%input:
%RGB - (M x N x 3 uint8) RGB color image to be transformed.

%output:
%LAB - (M x N x 3 float) LAB color image result.

%Get image size to simplify reshaping
M = size(RGB, 1);
N = size(RGB, 2);

%Transform from RGB to LMS cone space
LMSTransform = [0.3811 0.5783 0.0402;...
                  0.1967 0.7244 0.0782;...
                  0.0241 0.1288 0.8444];
LMS = LMSTransform * reshape(RGB, [M*N 3 1]).';

%Transform from LMS to LAB space
LABTransform = diag([1/sqrt(3) 1/sqrt(6) 1/sqrt(2)]) * ...
    [1 1 1; 1 1 -2; 1 -1 0];
LAB = LABTransform * log10(LMS);

%reshape result
LAB = reshape(LAB.', [M N 3]);
