function Normalized = Reinhard(I, TargetMu, TargetSigma, W, Mask)
%Performs Reinhard color normalization to map input image statistics to
%target image statistics in LAB color space.

%inputs:
%I - (M x N x 3 uint8) RGB color image to be normalized.
%TargetMu - (3-length float) Mean values of target color normalization
%           image in LAB color space. Can be extracted using ReinhardStats.
%TargetSigma - (3-length float) Mean values of target color normalization
%              image in LAB color space. Can be extracted using
%              ReinhardStats.
%W - (2 x 4 float) Linear discriminant parameters for masking tissue
%    from background. Used for color normalization. Default value
%    [-0.154 0.035 0.549 -45.718; -0.057 -0.817 1.170 -49.887].
%Mask - (M x N logical) Mask of pixels to use in calculating normalization
%       parameters. Optional. Can be provided as an alternative to
%       performing the linear discriminant analysis.

%outputs:
%Normalized - (M x N x 3 uint8) Normalized RGB color image.

%notes:
%Excluding background pixels from the normalization process improves
%performance. The Fisher's linear discriminant function coefficients are
%used to operate on the RGB pixel values:
% DiscriminantF_BG =  W(1,1)*R + W(1,2)*G + W(1,3)*B + W(1,4);
% DiscriminantF_FG =  W(2,1)*R + W(2,2)*G + W(2,3)*B + W(2,4);

%Parse inputs and define tissue mask
switch nargin
    case 3
        W = [-0.154 0.035 0.549 -45.718; -0.057 -0.817 1.170 -49.887];
        Mask = [];
    case 4
        Mask = [];
end

%Get image size to simplify reshaping
M = size(I, 1);
N = size(I, 2);

%convert input type if necessary
if ~isfloat(I)
    I = single(I);
end

%Classify foreground/background if 'Mask' not provided
if isempty(Mask)
    Mask = ForegroundDiscriminant(I, W);
end

%Get LAB statistics of input image
[SourceMu, SourceSigma, LAB] = LABStats(I, Mask);

%Normalize foreground pixels to target statistics in LAB space
Mask = reshape(Mask, [M*N 1]);
LAB = reshape(LAB, [M*N 3]).';
LAB(:,Mask) = (LAB(:,Mask) - SourceMu * ones(1,size(LAB(:,Mask),2))) .* ...
    ((TargetSigma ./ SourceSigma) * ones(1,size(LAB(:,Mask),2)));
LAB(:,Mask) = LAB(:,Mask) + TargetMu * ones(1,size(LAB(:,Mask),2));
LAB = reshape(LAB.', [M N 3]);

%Convert normalized image to RGB
Normalized = uint8(255 * LAB2RGB(LAB));
