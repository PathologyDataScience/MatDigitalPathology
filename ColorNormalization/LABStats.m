function [Mu, Sigma, LAB] = LABStats(I, Mask)
%Extracts first and second moment statistics from input RGB image 'I' in 
%the LAB color space. Statistics are calculated in a masked region
%containing tissue and not glass/background.

%inputs:
%I - (M x N x 3 float) RGB color image.
%Mask - (M x N logical) Mask of pixels to use in calculating normalization
%       parameters. Optional. Can be provided as an alternative to
%       performing the linear discriminant analysis.

%outputs:
%Mu - (3-length float) Mean values of target color normalization image in 
%     LAB color space.
%Sigma - (3-length float) Mean values of target color normalization image
%        in LAB color space.
%LAB - (M x N x 3 float) LAB color image result.

%Get image size to simplify reshaping
M = size(I, 1);
N = size(I, 2);

%transform image to LAB space
LAB = RGB2LAB(I / 255);

%transform to vectorized format
vLAB = reshape(LAB, [M*N 3]).';

%mask and remove NaN and Inf entries
Discard = sum(isnan(vLAB), 1) > 0 | sum(vLAB == -Inf, 1) > 0 | ...
    reshape(~Mask, [M*N 1]).';
vLAB(:, Discard) = [];

%Get LAB statistics of input image
Mu = mean(vLAB, 2);
Sigma = std(vLAB, [], 2);
