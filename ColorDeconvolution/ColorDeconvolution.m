function [Intensity, Complemented] = ColorDeconvolution(I, M, Stains, Complement)
%Deconvolves multiple stains from RGB image I, given stain calibration matrix 'M'.
%
%inputs:
%I - (m x n x 3 uint8) RGB image.
%M - (3 x 3 float) Color calibration matrix with vectors in columns. Minumum two nonzero 
%	 columns required. Zero the third column for two-stain images.  
%Stains - (3-length logical) Indicator of which output channels to produce. Corresponds to
%		  columns of 'M'.
%Complement - (scalar logical) True if complementation desired.
%
%output:
%Intensity - (m x n x sum(stains)) Single precision deconvolved intensity images. Channels
%			 are ordered as the columns of 'M'.
%Compelemented - (3 x 3 float) The complemented 3x3 version of 'M' with the third column
%				 containing the orthonormal complement of the first two columns.
%
%notes:
%This implements the Ruifrok and Johnston algorithm for color deconvolution. An example
%calibration matrix for hematoxylin and eosin images - M = [0.650 0.072 0; 0.704 0.990 0;
%  0.286 0.105 0];

if nargin == 3 %check arguments
    Complement = false;
end

m = size(I,1); n = size(I,2); %get input image size

for i = 1:3 %normalize stains
   if(norm(M(:,i), 2) >= eps)
       M(:,i) = M(:,i)/norm(M(:,i));
   end
end

if(Complement || norm(M(:,3)) < eps) %only two colors specified
    M = ComplementStains(M);
    Complemented = M;
else
    Complemented = [];
end

Q = inv(M); %inversion
Q = single(Q(logical(Stains),:));

I = single(Im2Vec(I)); %vectorize & correct zero entries
I(I == 0) = eps;

dn = DeconvolutionNormalize(I); %transform

cn = Q * dn; %unmix

channels = DeconvolutionDenormalize(cn); %invert transformation

 %format output
Intensity = single(zeros(m, n, sum(Stains)));
for i = 1:sum(Stains)
   Intensity(:,:,i) = reshape(channels(i,:), [m n]);
end
