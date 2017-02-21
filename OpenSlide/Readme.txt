Note for Mac - Matlab will try to load the dynamic library for an older version of tiff.
To use the openslide mex code, you need to launch matlab in the following way

DYLD_INSERT_LIBRARIES=/opt/local/lib/libtiff.5.dylib path_to_matlab_executable