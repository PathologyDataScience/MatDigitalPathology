function Mask = ForegroundDiscriminant(I, W)
%Uses linear discriminant to mask tissue pixels from background/glass.
%inputs:
%I - (M x N x 3 uint8) RGB color image for pixel classification.
%W - (2 x 4 float) Linear discriminant parameters for masking tissue
%    from background. Used for color normalization. Default value
%    [-0.154 0.035 0.549 -45.718; -0.057 -0.817 1.170 -49.887].
%ouput:
%Mask - (M x N logical) Mask where tissue pixels have value true.

%Parse inputs and assign default values.
if nargin == 1
    W  = [-0.154 0.035 0.549 -45.718; -0.057 -0.817 1.170 -49.887];
end

%Get image size to simplify reshaping
M = size(I, 1);
N = size(I, 2);

%Calculate discriminants
Discriminants = W * [reshape(I, [M*N 3 1]).'; ones(1, M*N)];

%Generate mask
Mask = Discriminants(1,:) > Discriminants(2,:);
Mask = reshape(Mask, [M N]);
