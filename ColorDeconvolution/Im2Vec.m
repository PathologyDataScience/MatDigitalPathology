function Vec = Im2Vec(I)
%Converts planar image formats to column-vector format.
%
%input:
%I - (M x N x K) K-channel image with channels in third/planar dimension.
%
%output:
%Vec - (K x MN) Vectorized image values where each column is a multichannel
%      pixel.

Vec = reshape(I, [size(I,1)*size(I,2) size(I,3)]).';
