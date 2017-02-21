function Normalized = DeconvolutionNormalize(Data)
%Bouguer-Lambert-Beer transformation of RGB color values.
%
%inputs:
%Data - (3 x N float) RGB color vectors.
%
%output:
%Normalized - 3 x N matrix of normalized color vectors (type double or
%single)

Normalized = -(255*log(Data/255))/log(255);
