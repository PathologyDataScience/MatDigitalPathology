## MatDigitalPathology
MatDigitalPathology contains Matlab functions and interfaces to support analysis of digital pathology images. It currently provides the following capabilities:

+ __Color Normalization__
  + Standardization of color images to improve the consistency of segmentation and feature extraction algorithms, including Reinhard normalization.
+ __Color Deconvolution__
  + Deconvolution of color images into intensity images representing consituent stains.
+ __OpenSlide Interface__
  + A mex interface to the [OpenSlide](http://openslide.org/) library for reading whole-slide imaging formats.
  
## Building the OpenSlide interface
The OpenSlide interface can be built using mex and linking the OpenSlide library  
```matlab
mex -L/opt/lib/ -lopenslide -I/opt/include/openslide/ openslide_can_open.C
```

## Using the OpenSlide interface
Some versions of Matlab may load a version of LibTIFF that is different from what the OpenSlide functions require. On Mac this can be overcome by calling the Matlab executable with code injection:

```
DYLD_INSERT_LIBRARIES=/opt/local/lib/libtiff.5.dylib path_to_matlab_executable
```

On recent versions of OSX code injection is been prevented for security and can be enabled by disabling system integrity protection.
