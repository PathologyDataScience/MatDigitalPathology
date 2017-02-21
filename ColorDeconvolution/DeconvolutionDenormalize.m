function Denormalized = DeconvolutionDenormalize(Data)
%Bouguer-Lambert-Beer invervse transformation to RGB color values.
%
%inputs:
%data - (3 x N float) Absorbance values in Lambert-Beer space in columns.
%
%outputs:
%Denormalized - (3 x N float) RBG color vectors in columns.

Denormalized = exp(-(Data - 255)*log(255)/255);
