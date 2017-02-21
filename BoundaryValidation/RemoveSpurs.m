function [XClean, YClean] = RemoveSpurs(X, Y)
%Removes spur points from polyline, defined as two sequential polyline 
%segments that overlap (Ex. x = [0 2 1], y = [0 0 0] or x = [0 1 1 1 0], 
%y = [0 0 1 0 2].)
%
%input:
%X - (N-length float or int) Polyline vertex horizontal coordinates.
%Y - (N-length float or int) Polyline vertex vertical coordinates.
%
%output:
%XClean - (N-length float or int) Polyline vertex horizontal coordinates 
%         with spurs removed.
%YClean - (N-length float or int) Polyline vertex vertical coordinates 
%         with spurs removed.

%compute differentials
dX = diff(X);
dY = diff(Y);

%detect and delete stationary repeats
repeats = find((dX == 0) & (dY == 0));
X(repeats) = []; Y(repeats) = [];
dX(repeats) = []; dY(repeats) = [];

%calculate slope
slope = dY ./ dX;

%detect segments where slope(i+1) = slope(i)
spurs = find((slope(1:end-1) == -slope(2:end)) & ...
        (sign(dX(1:end-1)) == -sign(dX(2:end))) & ...
        (sign(dY(1:end-1)) == -sign(dY(2:end))) );

%remove offending vertices
X(spurs+1) = [];
Y(spurs+1) = [];

%copy for output
XClean = X;
YClean = Y;
