function RGB = LAB2RGB(LAB)
%Converts RGB image to LAB colorspace.

%input:
%LAB - (M x N x 3 float) LAB color image to be transformed.

%output:
%RGB - (M x N x 3 float) RGB color image result.

%Get image size to simplify reshaping
M = size(LAB, 1);
N = size(LAB, 2);

%Transform from LAB to LMS
LMSTransform =  [1 1 1; 1 1 -1; 1 -2 0] * ...
    diag([sqrt(3)/3 sqrt(6)/6 sqrt(2)/2]);
LMS = 10 .^ [LMSTransform * reshape(LAB, [M*N 3 1]).'];

%Correct out of range values
LMS(LMS == -Inf) = 0;
LMS(isnan(LMS)) = 0;

%Transform from LMS to LAB
RGBTransform = [4.4687 -3.5887 0.1196;...
                -1.2197 2.3831 -0.1626;...
                0.0585 -0.2611 1.2057];
RGB = RGBTransform * LMS;

%reshape result
RGB = reshape(RGB.', [M N 3]);
