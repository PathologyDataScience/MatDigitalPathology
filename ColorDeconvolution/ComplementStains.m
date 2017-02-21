function Complemented = ComplementStains(M)
%Used in color deconvolution to complement the stains with a unit-norm orthogonal
%component.
%
%inputs:
%M - (3 x 3 float) Stain calibration matrix with stain vectors in columns.
%
%outputs:
%Compelemented - (3 x 3 float) Complementation of 'M' where the third column contains the
%				 orthonormal complement of the first two.

%copy input to Complemented
Complemented = M;

%complement
if ((M(1,1)^2 + M(1,2)^2) > 1)
    Complemented(1,3) = 0;
else
    Complemented(1,3) = sqrt(1 - (M(1,1)^2 + M(1,2)^2));
end

if ((M(2,1)^2 + M(2,2)^2) > 1)
    Complemented(2,3) = 0;
else
    Complemented(2,3) = sqrt(1 - (M(2,1)^2 + M(2,2)^2));
end

if ((M(3,1)^2 + M(3,2)^2) > 1)
    Complemented(3,3) = 0;
else
    Complemented(3,3) = sqrt(1 - (M(3,1)^2 + M(3,2)^2));
end

Complemented(:,3) = Complemented(:,3)/norm(Complemented(:,3));
