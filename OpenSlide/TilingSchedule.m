function [Level, Scale, Tout, Factor, X, Y, dX, dY] = ...
                                        TilingSchedule(Slide, Desired, T)
%Generates a tiling schedule for a slide at a given resolution 'Desired'
%and tilesize 'T'.

%inputs:
%Slide - string, path and filename of input slide
%Desired - scalar, desired magnification for analysis.
%T - tilesize at desired magnification.

%outputs:
%Level - scalar, pyramid level for use with 'openslide_read_region'.
%Scale - scale between desired magnification and base magnification (scan
%        magnification).
%Tout - scalar, tilesize at magnification used for reading.
%Factor - scalar, rescaling needed for output tiles with imresize.
%X - vector, list of horizontal coordinates for tiling at base 
%    magnifcation. Used in subsequent calls to openslide_read_regions.
%Y - vector, list of vertical coordinates for tiling at base 
%    magnification. Used in subsequent calls to openslide_read_regions.
%dX - vector, list of horizontal coordinates at desired magnification. Used
%     for display of boundaries and navigation.
%dY - vector, list of vertical coordinates at desired magnification. Used 
%     for display of boundaries and navigation.

%parameters
tol = 0.002; %desired magnification mismatch tolerance

%check if slide can be opened
Valid = openslide_can_open(Slide);

%slide is a valid file
if(Valid)
    
    %get slide dimensions, zoom levels, and objective information
    [Dims, Factors, Objective] = openslide_check_levels(Slide);
    
    %get objective magnification of level 1 (scanning objective)
    Objective = str2double(Objective);
    
    %solve magnification levels
    if(~isnan(Objective))
        Magnifications = Objective ./ Factors;
    else
        error('No objective provided in image metadata.');
    end

    %find highest magnification level that is greater than or equal to 'Desired'
    Mismatch = Magnifications - Desired;
    if(min(abs(Mismatch)) <= tol)
        [~, Level] = min(abs(Mismatch));
        Factor = 1;
    else %pick next highest level, downsample
        Level = max(find(Mismatch > 0));
        Factor = Desired / Magnifications(Level);
    end
    
    %adjust tilesize based on downsampling factor
    Tout = round(T / Factor);
    
    %generate X, Y coordinates for tiling
    Stride = Tout * Magnifications(1) / Magnifications(Level);
    X = 0 : Stride : Dims(1,2);
    Y = 0 : Stride : Dims(1,1);
    [X, Y] = meshgrid(X, Y);
    X = X(:);
    Y = Y(:);
    dX = X / (Magnifications(1) / Desired);
    dY = Y / (Magnifications(1) / Desired);
    
    %calculate scale
    Scale = Desired / Objective;
    
    %correct level to zero-index (openslide uses zero indexing of layers)
    Level = Level-1;
    

else %cannot read slide, return empty values
    
    %assign empty values to outputs
    Level = [];
    Scale = [];
    Tout = [];
    Factor = [];
    X = [];
    Y = [];
    dX = [];
    dY = [];
    
end