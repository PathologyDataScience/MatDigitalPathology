function [XMerged, YMerged] = MergeColinear(X, Y)
%Merges consecutive colinear segments in polyline contour with vertices 'X'
%and 'Y'. Compresses boundaries for storage, managment and analysis.
%
%input:
%X - (N-length float or int) Polyline vertex horizontal coordinates.
%Y - (N-length float or int) Polyline vertex vertical coordinates.
%
%output:
%XMerged - (N-length float or int) Polyline vertex horizontal coordinates 
%          with colinear vertices merged.
%YMerged - (N-length float or int) Polyline vertex vertical coordinates 
%          with colinear vertices merged.

%compute differentials
dX = diff(X);
dY = diff(Y);

%detect and delete stationary repeats
repeats = find((dX == 0) & (dY == 0));
X(repeats) = []; Y(repeats) = [];
dX(repeats) = []; dY(repeats) = [];

%calculate slope
slope = dY ./ dX;

%find slope transitions
dslope = diff(slope);
dslope(isnan(dslope)) = 0;

%identify slope transitions
transitions = find(dslope ~= 0);

%build merged sequences
XMerged = nan(1, length(transitions)+2);
YMerged = nan(1, length(transitions)+2);
XMerged(1) = X(1);
YMerged(1) = Y(1);
for i = 1:length(transitions)
    XMerged(i+1) = X(transitions(i)+1);
    YMerged(i+1) = Y(transitions(i)+1);
end
XMerged(end) = X(end);
YMerged(end) = Y(end);
